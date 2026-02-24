import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/quran_local_datasource.dart';
import '../../data/repositories/quran_repository_impl.dart';
import '../../domain/entities/ayah_entity.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/entities/surah_entity.dart';
import '../../domain/entities/reading_position_entity.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../domain/usecases/get_all_surahs.dart';
import '../../domain/usecases/get_ayahs_by_page.dart';
import '../../domain/usecases/manage_bookmarks.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Repository provider ──
final quranLocalDatasourceProvider = Provider<QuranLocalDatasource>(
  (_) => QuranLocalDatasourceImpl(),
);

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepositoryImpl(
    local: ref.read(quranLocalDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// ── Use case providers ──
final getAllSurahsProvider = Provider((ref) =>
    GetAllSurahs(ref.read(quranRepositoryProvider)));
final getAyahsByPageProvider = Provider((ref) =>
    GetAyahsByPage(ref.read(quranRepositoryProvider)));
final getBookmarksProvider = Provider((ref) =>
    GetBookmarks(ref.read(quranRepositoryProvider)));
final addBookmarkProvider = Provider((ref) =>
    AddBookmark(ref.read(quranRepositoryProvider)));
final removeBookmarkProvider = Provider((ref) =>
    RemoveBookmark(ref.read(quranRepositoryProvider)));

// ── State: Surah list ──
final surahListStateProvider = FutureProvider<List<SurahEntity>>((ref) async {
  final usecase = ref.read(getAllSurahsProvider);
  final result = await usecase(const NoParams());
  return result.fold((f) => throw f.message, (surahs) => surahs);
});

// ── State: Page ayahs ──
final pageAyahsProvider = FutureProvider.family<List<AyahEntity>, int>((ref, page) async {
  final usecase = ref.read(getAyahsByPageProvider);
  final result = await usecase(page);
  return result.fold((f) => throw f.message, (ayahs) => ayahs);
});

// ── State: Current reading page ──
final currentPageProvider = StateProvider<int>((ref) => 1);

// ── State: Arabic font ──
final arabicFontProvider = StateProvider<String>((ref) => 'Uthmani');

// ── State: Arabic font size ──
final arabicFontSizeProvider = StateProvider<double>((ref) => 28.0);

// ── State: Show translation ──
final showTranslationProvider = StateProvider<bool>((ref) => true);

// ── State: Tajweed enabled ──
final tajweedEnabledProvider = StateProvider<bool>((ref) => false);

// ── State: Bookmarks ──
final bookmarksStateProvider = FutureProvider<List<BookmarkEntity>>((ref) async {
  final usecase = ref.read(getBookmarksProvider);
  final result = await usecase(const NoParams());
  return result.fold((f) => throw f.message, (b) => b);
});

// ── State: Last reading position ──
final lastPositionProvider = FutureProvider<ReadingPositionEntity?>((ref) async {
  final repo = ref.read(quranRepositoryProvider);
  final result = await repo.getLastPosition();
  return result.fold((_) => null, (pos) => pos);
});

// ── State: Selected reciter ──
final selectedReciterProvider = StateProvider<String>((ref) => 'ar.alafasy');

// ── Quran search ──
final searchQueryProvider = StateProvider<String>((ref) => '');
final searchResultsProvider = FutureProvider<List<AyahEntity>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  final repo = ref.read(quranRepositoryProvider);
  final result = await repo.searchAyahs(query);
  return result.fold((_) => [], (r) => r);
});