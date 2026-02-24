import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class HiveBoxes {
  static Future<void> registerAdapters() async {
    // Adapters registered in their respective model files
  }

  static Future<void> openBoxes() async {
    await Future.wait([
      Hive.openBox(AppConstants.boxSettings),
      Hive.openBox(AppConstants.boxBookmarks),
      Hive.openBox(AppConstants.boxHighlights),
      Hive.openBox(AppConstants.boxReadingGoals),
      Hive.openBox(AppConstants.boxReadingSessions),
      Hive.openBox(AppConstants.boxDownloads),
      Hive.openBox(AppConstants.boxDhikr),
      Hive.openBox(AppConstants.boxQuranCache),
    ]);
  }
}