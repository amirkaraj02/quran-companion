import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/ayah_entity.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/entities/highlight_entity.dart';
import '../../domain/entities/reading_position_entity.dart';
import '../../domain/entities/surah_entity.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_local_datasource.dart';
import '../models/bookmark_model.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDatasource _local;
  final NetworkInfo _networkInfo;

  const QuranRepositoryImpl({
    required QuranLocalDatasource local,
    required NetworkInfo networkInfo,
  })  : _local = local,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<SurahEntity>>> getAllSurahs() async {
    try {
      final models = await _local.getAllSurahs();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<AyahEntity>>> getAyahsByPage(int page) async {
    try {
      final models = await _local.getAyahsByPage(page);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<AyahEntity>>> getAyahsBySurah(int surahNumber) async {
    try {
      final models = await _local.getAyahsBySurah(surahNumber);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, AyahEntity>> getAyah(int surah, int ayah) async {
    try {
      final ayahs = await _local.getAyahsBySurah(surah);
      final found = ayahs.firstWhere(
        (a) => a.ayahNumber == ayah,
        orElse: () => throw CacheException(message: 'Ayah not found'),
      );
      return Right(found.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<AyahEntity>>> searchAyahs(String query) async {
    try {
      final models = await _local.searchAyahs(query);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<BookmarkEntity>>> getBookmarks() async {
    try {
      final models = await _local.getBookmarks();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addBookmark(BookmarkEntity bookmark) async {
    try {
      await _local.saveBookmark(BookmarkModel.fromEntity(bookmark));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String id) async {
    try {
      await _local.deleteBookmark(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<HighlightEntity>>> getHighlights() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> addHighlight(HighlightEntity highlight) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> removeHighlight(String id) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, ReadingPositionEntity?>> getLastPosition() async {
    try {
      final pos = await _local.getLastPosition();
      return Right(pos);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveLastPosition(ReadingPositionEntity position) async {
    try {
      await _local.saveLastPosition(position);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getAudioUrl(int surahNumber, String reciter) async {
    final padded = surahNumber.toString().padLeft(3, '0');
    final url = 'https://cdn.islamic.network/quran/audio-surah/128/$reciter/$padded.mp3';
    return Right(url);
  }

  @override
  Future<Either<Failure, bool>> isAudioDownloaded(int surahNumber) async {
    return const Right(false);
  }

  @override
  Future<Either<Failure, void>> downloadAudio(int surahNumber, String reciter) async {
    return const Right(null);
  }
}