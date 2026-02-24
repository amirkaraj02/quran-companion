import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, sepia }

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.light) { _load(); }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final v = p.getString('theme_mode') ?? 'light';
    state = AppThemeMode.values.firstWhere((e) => e.name == v, orElse: () => AppThemeMode.light);
  }

  Future<void> set(AppThemeMode mode) async {
    state = mode;
    final p = await SharedPreferences.getInstance();
    await p.setString('theme_mode', mode.name);
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((_) => ThemeNotifier());
final themeModeProvider = Provider<ThemeMode>((ref) {
  final m = ref.watch(themeNotifierProvider);
  return m == AppThemeMode.dark ? ThemeMode.dark : ThemeMode.light;
});