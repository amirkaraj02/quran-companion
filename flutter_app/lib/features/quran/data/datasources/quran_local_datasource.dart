import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/surah_model.dart';
import '../models/ayah_model.dart';
import '../models/bookmark_model.dart';
import '../../domain/entities/reading_position_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class QuranLocalDatasource {
  Future<List<SurahModel>> getAllSurahs();
  Future<List<AyahModel>> getAyahsByPage(int page);
  Future<List<AyahModel>> getAyahsBySurah(int surahNumber);
  Future<List<BookmarkModel>> getBookmarks();
  Future<void> saveBookmark(BookmarkModel bookmark);
  Future<void> deleteBookmark(String id);
  Future<ReadingPositionEntity?> getLastPosition();
  Future<void> saveLastPosition(ReadingPositionEntity position);
  Future<List<AyahModel>> searchAyahs(String query);
}

class QuranLocalDatasourceImpl implements QuranLocalDatasource {
  final Box _settingsBox;
  final Box _bookmarksBox;

  QuranLocalDatasourceImpl()
      : _settingsBox = Hive.box(AppConstants.boxSettings),
        _bookmarksBox = Hive.box(AppConstants.boxBookmarks);

  // Load Surahs from bundled asset JSON
  @override
  Future<List<SurahModel>> getAllSurahs() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/quran/surahs.json');
      final List<dynamic> data = json.decode(jsonStr);
      return data.map((j) => SurahModel.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) {
      throw CacheException(message: 'Could not load surahs: $e');
    }
  }

  @override
  Future<List<AyahModel>> getAyahsByPage(int page) async {
    try {
      final jsonStr = await rootBundle.loadString('assets/quran/page_$page.json');
      final List<dynamic> data = json.decode(jsonStr);
      return data.map((j) => AyahModel.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) {
      throw CacheException(message: 'Page $page not found in assets: $e');
    }
  }

  @override
  Future<List<AyahModel>> getAyahsBySurah(int surahNumber) async {
    try {
      final jsonStr = await rootBundle.loadString('assets/quran/surah_$surahNumber.json');
      final List<dynamic> data = json.decode(jsonStr);
      return data.map((j) => AyahModel.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) {
      throw CacheException(message: 'Surah $surahNumber not found: $e');
    }
  }

  @override
  Future<List<BookmarkModel>> getBookmarks() async {
    return _bookmarksBox.values
        .whereType<Map>()
        .map((m) => BookmarkModel.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  Future<void> saveBookmark(BookmarkModel bookmark) async {
    await _bookmarksBox.put(bookmark.id, bookmark.toJson());
  }

  @override
  Future<void> deleteBookmark(String id) async {
    await _bookmarksBox.delete(id);
  }

  @override
  Future<ReadingPositionEntity?> getLastPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final page = prefs.getInt('last_page');
    if (page == null) return null;
    return ReadingPositionEntity(
      pageNumber: page,
      surahNumber: prefs.getInt('last_surah') ?? 1,
      ayahNumber: prefs.getInt('last_ayah') ?? 1,
      lastRead: DateTime.tryParse(prefs.getString('last_read') ?? '') ?? DateTime.now(),
    );
  }

  @override
  Future<void> saveLastPosition(ReadingPositionEntity pos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_page', pos.pageNumber);
    await prefs.setInt('last_surah', pos.surahNumber);
    await prefs.setInt('last_ayah', pos.ayahNumber);
    await prefs.setString('last_read', pos.lastRead.toIso8601String());
  }

  @override
  Future<List<AyahModel>> searchAyahs(String query) async {
    // Search in loaded surahs (offline-first approach)
    // For production: use pre-built SQLite FTS index
    final results = <AyahModel>[];
    final q = query.toLowerCase();
    for (int s = 1; s <= 114; s++) {
      try {
        final ayahs = await getAyahsBySurah(s);
        results.addAll(ayahs.where((a) =>
          a.translationEnglish.toLowerCase().contains(q) ||
          a.translationAlbanian.toLowerCase().contains(q) ||
          a.textArabic.contains(query)
        ));
        if (results.length > 50) break;
      } catch (_) {}
    }
    return results;
  }
}