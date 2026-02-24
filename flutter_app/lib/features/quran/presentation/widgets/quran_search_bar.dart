import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ayah_entity.dart';
import '../providers/quran_provider.dart';
import '../../../../core/theme/app_theme.dart';

class QuranSearchDelegate extends SearchDelegate<AyahEntity?> {
  final WidgetRef ref;
  QuranSearchDelegate(this.ref);

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) {
    ref.read(searchQueryProvider.notifier).state = query;
    return Consumer(
      builder: (_, ref, __) {
        final resultsAsync = ref.watch(searchResultsProvider);
        return resultsAsync.when(
          data: (ayahs) => ayahs.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: ayahs.length,
                  itemBuilder: (_, i) => ListTile(
                    title: Text(ayahs[i].textUthmani,
                        style: const TextStyle(fontFamily: 'Uthmani', fontSize: 18),
                        textDirection: TextDirection.rtl),
                    subtitle: Text(ayahs[i].translationEnglish),
                    trailing: Text('${ayahs[i].surahNumber}:${ayahs[i].ayahNumber}',
                        style: const TextStyle(color: AppColors.primary)),
                    onTap: () => close(context, ayahs[i]),
                  ),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}