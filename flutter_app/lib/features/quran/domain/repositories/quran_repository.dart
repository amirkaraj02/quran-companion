import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/ayah_entity.dart';
import '../entities/surah_entity.dart';
import '../entities/bookmark_entity.dart';
import '../entities/highlight_entity.dart';
import '../entities/reading_position_entity.dart';

abstract class QuranRepository {
  Future<Either<Failure, List<SurahEntity>>> getAllSurahs();
  Future<Either<Failure, List<AyahEntity>>> getAyahsByPage(int page);
  Future<Either<Failure, List<AyahEntity>>> getAyahsBySurah(int surahNumber);
  Future<Either<Failure, AyahEntity>> getAyah(int surah, int ayah);
  Future<Either<Failure, List<AyahEntity>>> searchAyahs(String query);

  // Bookmarks
  Future<Either<Failure, List<BookmarkEntity>>> getBookmarks();
  Future<Either<Failure, void>> addBookmark(BookmarkEntity bookmark);
  Future<Either<Failure, void>> removeBookmark(String id);

  // Highlights
  Future<Either<Failure, List<HighlightEntity>>> getHighlights();
  Future<Either<Failure, void>> addHighlight(HighlightEntity highlight);
  Future<Either<Failure, void>> removeHighlight(String id);

  // Position
  Future<Either<Failure, ReadingPositionEntity?>> getLastPosition();
  Future<Either<Failure, void>> saveLastPosition(ReadingPositionEntity position);

  // Audio
  Future<Either<Failure, String>> getAudioUrl(int surahNumber, String reciter);
  Future<Either<Failure, bool>> isAudioDownloaded(int surahNumber);
  Future<Either<Failure, void>> downloadAudio(int surahNumber, String reciter);
}