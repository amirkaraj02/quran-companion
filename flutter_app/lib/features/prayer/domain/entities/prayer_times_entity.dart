class PrayerTimesEntity {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime date;
  final String cityName;
  final String calculationMethod;

  const PrayerTimesEntity({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
    required this.cityName,
    required this.calculationMethod,
  });

  String? get nextPrayerName {
    final now = DateTime.now();
    if (now.isBefore(fajr)) return 'Fajr';
    if (now.isBefore(dhuhr)) return 'Dhuhr';
    if (now.isBefore(asr)) return 'Asr';
    if (now.isBefore(maghrib)) return 'Maghrib';
    if (now.isBefore(isha)) return 'Isha';
    return null; // After Isha
  }

  DateTime? get nextPrayerTime {
    final now = DateTime.now();
    if (now.isBefore(fajr)) return fajr;
    if (now.isBefore(dhuhr)) return dhuhr;
    if (now.isBefore(asr)) return asr;
    if (now.isBefore(maghrib)) return maghrib;
    if (now.isBefore(isha)) return isha;
    return null;
  }

  Duration? get timeToNextPrayer {
    final next = nextPrayerTime;
    if (next == null) return null;
    return next.difference(DateTime.now());
  }

  List<PrayerEntry> get all => [
    PrayerEntry('Fajr', fajr, 'الفجر'),
    PrayerEntry('Sunrise', sunrise, 'الشروق'),
    PrayerEntry('Dhuhr', dhuhr, 'الظهر'),
    PrayerEntry('Asr', asr, 'العصر'),
    PrayerEntry('Maghrib', maghrib, 'المغرب'),
    PrayerEntry('Isha', isha, 'العشاء'),
  ];
}

class PrayerEntry {
  final String name;
  final DateTime time;
  final String nameArabic;
  const PrayerEntry(this.name, this.time, this.nameArabic);
}