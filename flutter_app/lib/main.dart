import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/di/injection.dart';
import 'core/services/notification_service.dart';
import 'core/storage/hive_boxes.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Init Hive
  await Hive.initFlutter();
  await HiveBoxes.registerAdapters();
  await HiveBoxes.openBoxes();

  // Init timezone
  tz.initializeTimeZones();

  // Init notifications
  await NotificationService.initialize();

  // Init DI
  await configureDependencies();

  runApp(
    const ProviderScope(
      child: QuranCompanionApp(),
    ),
  );
}
