import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('sq')) { _load(); }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = Locale(p.getString('locale') ?? 'sq');
  }

  Future<void> set(Locale locale) async {
    state = locale;
    final p = await SharedPreferences.getInstance();
    await p.setString('locale', locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((_) => LocaleNotifier());