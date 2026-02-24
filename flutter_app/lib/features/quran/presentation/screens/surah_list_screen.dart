import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/quran_provider.dart';
import '../widgets/surah_list_tile.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/theme/app_theme.dart';

class SurahListScreen extends ConsumerWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Surahs — السور'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: surahsAsync.when(
        data: (surahs) => ListView.builder(
          itemCount: surahs.length,
          itemBuilder: (ctx, i) => SurahListTile(
            surah: surahs[i],
            onTap: () => context.push('/quran/reader', extra: {
              'surah': surahs[i].number,
              'page': surahs[i].startPage,
            }),
          ),
        ),
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}