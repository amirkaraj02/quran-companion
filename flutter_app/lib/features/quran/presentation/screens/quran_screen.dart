import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/quran_provider.dart';
import '../widgets/surah_list_tile.dart';
import '../widgets/quran_search_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';

class QuranScreen extends ConsumerWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListStateProvider);
    final lastPosAsync = ref.watch(lastPositionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: QuranSearchDelegate(ref),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showSettings(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Continue reading banner
          lastPosAsync.when(
            data: (pos) {
              if (pos == null) return const SizedBox.shrink();
              return _ContinueReadingBanner(pos: pos);
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          // Navigation tabs
          _QuranNavTabs(),
          Expanded(
            child: surahsAsync.when(
              data: (surahs) => ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: surahs.length,
                itemBuilder: (ctx, i) => SurahListTile(
                  surah: surahs[i],
                  onTap: () => context.push('/quran/reader', extra: {
                    'surah': surahs[i].number,
                    'page': surahs[i].startPage,
                  }),
                ),
              ),
              loading: () => const LoadingWidget(message: 'Loading Quran...'),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(surahListStateProvider),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/quran/reader'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.menu_book, color: Colors.white),
        label: const Text('Open by Page', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showSettings(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ReaderSettingsSheet(),
    );
  }
}

class _ContinueReadingBanner extends ConsumerWidget {
  final dynamic pos;
  const _ContinueReadingBanner({required this.pos});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.bookmark, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Continue Reading',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('Page ${pos.pageNumber} • Surah ${pos.surahNumber}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.push('/quran/reader', extra: {'page': pos.pageNumber}),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }
}

class _QuranNavTabs extends ConsumerStatefulWidget {
  @override
  ConsumerState<_QuranNavTabs> createState() => _QuranNavTabsState();
}

class _QuranNavTabsState extends ConsumerState<_QuranNavTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      labelColor: AppColors.primary,
      indicatorColor: AppColors.primary,
      tabs: const [
        Tab(text: 'Surah'),
        Tab(text: 'Juz'),
        Tab(text: 'Page'),
      ],
    );
  }
}

class _ReaderSettingsSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(arabicFontSizeProvider);
    final font = ref.watch(arabicFontProvider);
    final showTranslation = ref.watch(showTranslationProvider);
    final tajweed = ref.watch(tajweedEnabledProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reader Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Arabic Font Size'),
          Slider(
            value: fontSize,
            min: 18,
            max: 42,
            divisions: 8,
            label: fontSize.round().toString(),
            activeColor: AppColors.primary,
            onChanged: (v) => ref.read(arabicFontSizeProvider.notifier).state = v,
          ),
          const Text('Font Style'),
          DropdownButton<String>(
            value: font,
            isExpanded: true,
            items: ['Uthmani', 'IndoPak', 'NotoNaskhArabic', 'Amiri'].map((f) =>
              DropdownMenuItem(value: f, child: Text(f))).toList(),
            onChanged: (v) {
              if (v != null) ref.read(arabicFontProvider.notifier).state = v;
            },
          ),
          SwitchListTile(
            title: const Text('Show Translation'),
            value: showTranslation,
            activeColor: AppColors.primary,
            onChanged: (v) => ref.read(showTranslationProvider.notifier).state = v,
          ),
          SwitchListTile(
            title: const Text('Tajweed Colors'),
            value: tajweed,
            activeColor: AppColors.primary,
            onChanged: (v) => ref.read(tajweedEnabledProvider.notifier).state = v,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}