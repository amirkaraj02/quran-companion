import 'package:adhan/adhan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/prayer_settings_entity.dart';
import '../../domain/entities/prayer_times_entity.dart';

// ── Settings provider ──
final prayerSettingsProvider =
    StateNotifierProvider<PrayerSettingsNotifier, PrayerSettingsEntity>(
  (_) => PrayerSettingsNotifier(),
);

class PrayerSettingsNotifier extends StateNotifier<PrayerSettingsEntity> {
  PrayerSettingsNotifier()
      : super(const PrayerSettingsEntity(
          latitude: 41.3275,
          longitude: 19.8187,
          cityName: 'Tirana',
          calculationMethod: 'Diyanet',
        )) {
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = PrayerSettingsEntity(
      latitude: p.getDouble('prayer_lat') ?? 41.3275,
      longitude: p.getDouble('prayer_lng') ?? 19.8187,
      cityName: p.getString('prayer_city') ?? 'Tirana',
      calculationMethod: p.getString('prayer_method') ?? 'Diyanet',
      fajrNotificationEnabled: p.getBool('notif_fajr') ?? true,
      dhuhrNotificationEnabled: p.getBool('notif_dhuhr') ?? true,
      asrNotificationEnabled: p.getBool('notif_asr') ?? true,
      maghribNotificationEnabled: p.getBool('notif_maghrib') ?? true,
      ishaNotificationEnabled: p.getBool('notif_isha') ?? true,
    );
  }

  Future<void> updateLocation(double lat, double lng, String city) async {
    final p = await SharedPreferences.getInstance();
    await p.setDouble('prayer_lat', lat);
    await p.setDouble('prayer_lng', lng);
    await p.setString('prayer_city', city);
    state = state.copyWith(latitude: lat, longitude: lng, cityName: city);
  }

  Future<void> updateMethod(String method) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('prayer_method', method);
    state = state.copyWith(calculationMethod: method);
  }

  Future<void> detectLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );
      await updateLocation(pos.latitude, pos.longitude, 'Current Location');
    } catch (_) {}
  }

  Future<void> toggleNotification(String prayer, bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('notif_$prayer', value);
    state = switch (prayer) {
      'fajr' => state.copyWith(fajrNotificationEnabled: value),
      'dhuhr' => state.copyWith(dhuhrNotificationEnabled: value),
      'asr' => state.copyWith(asrNotificationEnabled: value),
      'maghrib' => state.copyWith(maghribNotificationEnabled: value),
      'isha' => state.copyWith(ishaNotificationEnabled: value),
      _ => state,
    };
  }
}

// ── Prayer times calculation provider ──
final prayerTimesProvider = Provider<PrayerTimesEntity?>((ref) {
  final settings = ref.watch(prayerSettingsProvider);
  try {
    final coords = Coordinates(settings.latitude, settings.longitude);
    final params = _getCalculationParams(settings.calculationMethod);
    final adhanTimes = PrayerTimes.today(coords, params);
    return PrayerTimesEntity(
      fajr: adhanTimes.fajr,
      sunrise: adhanTimes.sunrise,
      dhuhr: adhanTimes.dhuhr,
      asr: adhanTimes.asr,
      maghrib: adhanTimes.maghrib,
      isha: adhanTimes.isha,
      date: DateTime.now(),
      cityName: settings.cityName,
      calculationMethod: settings.calculationMethod,
    );
  } catch (e) {
    return null;
  }
});

CalculationParameters _getCalculationParams(String method) {
  switch (method) {
    case 'Diyanet':
      return CalculationMethod.turkey.getParameters();
    case 'MWL':
      return CalculationMethod.muslim_world_league.getParameters();
    case 'UmmAlQura':
      return CalculationMethod.umm_al_qura.getParameters();
    case 'Egyptian':
      return CalculationMethod.egyptian.getParameters();
    default:
      return CalculationMethod.turkey.getParameters();
  }
}