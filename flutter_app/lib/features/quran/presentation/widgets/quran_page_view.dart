import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quran_provider.dart';
import 'ayah_widget.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/providers/theme_provider.dart';

class QuranPageView extends ConsumerWidget {
  final int pageNumber;
  const QuranPageView({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayahsAsync = ref.watch(pageAyahsProvider(pageNumber));
    final themeMode = ref.watch(themeNotifierProvider);

    final bgColor = switch (themeMode) {
      AppThemeMode.dark => AppColors.bgDark,
      AppThemeMode.sepia => AppColors.bgSepia,
      AppThemeMode.light => AppColors.bgLight,
    };

    return Container(
      color: bgColor,
      child: ayahsAsync.when(
        data: (ayahs) => Column(
          children: [
            _PageHeader(pageNumber: pageNumber),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Group ayahs by surah and show Bismillah at surah starts
                    ...ayahs.map((ayah) => AyahWidget(ayah: ayah)),
                  ],
                ),
              ),
            ),
            _PageFooter(pageNumber: pageNumber),
          ],
        ),
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text('Page $pageNumber not available offline',
                  textAlign: TextAlign.center),
              const Text('Download Quran data to read offline',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  final int pageNumber;
  const _PageHeader({required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0D5C0), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Juz ${_pageToJuz(pageNumber)}',
              style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
          Text('Page $pageNumber',
              style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
          Text('Hizb ${_pageToHizb(pageNumber)}',
              style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  int _pageToJuz(int page) => ((page - 1) ~/ 20) + 1;
  int _pageToHizb(int page) => ((page - 1) ~/ 10) + 1;
}

class _PageFooter extends StatelessWidget {
  final int pageNumber;
  const _PageFooter({required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.circle, size: 4, color: AppColors.gold),
          const SizedBox(width: 6),
          Text('$pageNumber',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
          const SizedBox(width: 6),
          const Icon(Icons.circle, size: 4, color: AppColors.gold),
        ],
      ),
    );
  }
}