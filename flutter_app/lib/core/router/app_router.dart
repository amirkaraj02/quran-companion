import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/quran/presentation/screens/quran_screen.dart';
import '../../features/quran/presentation/screens/quran_reader_screen.dart';
import '../../features/quran/presentation/screens/surah_list_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/prayer/presentation/screens/prayer_screen.dart';
import '../../features/qibla/presentation/screens/qibla_screen.dart';
import '../../features/dhikr/presentation/screens/dhikr_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../widgets/main_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
          GoRoute(path: '/quran', builder: (c, s) => const QuranScreen()),
          GoRoute(path: '/progress', builder: (c, s) => const ProgressScreen()),
          GoRoute(path: '/prayer', builder: (c, s) => const PrayerScreen()),
          GoRoute(path: '/more', builder: (c, s) => const DhikrScreen()),
        ],
      ),
      GoRoute(
        path: '/quran/surahs',
        builder: (c, s) => const SurahListScreen(),
      ),
      GoRoute(
        path: '/quran/reader',
        builder: (c, s) {
          final extra = s.extra as Map<String, dynamic>?;
          return QuranReaderScreen(
            initialPage: extra?['page'] as int? ?? 1,
            initialSurah: extra?['surah'] as int?,
            initialAyah: extra?['ayah'] as int?,
          );
        },
      ),
      GoRoute(path: '/qibla', builder: (c, s) => const QiblaScreen()),
      GoRoute(path: '/dhikr', builder: (c, s) => const DhikrScreen()),
      GoRoute(path: '/auth/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/auth/register', builder: (c, s) => const RegisterScreen()),
    ],
  );
});