class PrayerSettingsEntity {
  final double latitude;
  final double longitude;
  final String cityName;
  final String calculationMethod;
  final bool fajrNotificationEnabled;
  final bool dhuhrNotificationEnabled;
  final bool asrNotificationEnabled;
  final bool maghribNotificationEnabled;
  final bool ishaNotificationEnabled;
  final bool useAdhan;

  const PrayerSettingsEntity({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    this.calculationMethod = 'Diyanet',
    this.fajrNotificationEnabled = true,
    this.dhuhrNotificationEnabled = true,
    this.asrNotificationEnabled = true,
    this.maghribNotificationEnabled = true,
    this.ishaNotificationEnabled = true,
    this.useAdhan = true,
  });

  PrayerSettingsEntity copyWith({
    double? latitude,
    double? longitude,
    String? cityName,
    String? calculationMethod,
    bool? fajrNotificationEnabled,
    bool? dhuhrNotificationEnabled,
    bool? asrNotificationEnabled,
    bool? maghribNotificationEnabled,
    bool? ishaNotificationEnabled,
    bool? useAdhan,
  }) => PrayerSettingsEntity(
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    cityName: cityName ?? this.cityName,
    calculationMethod: calculationMethod ?? this.calculationMethod,
    fajrNotificationEnabled: fajrNotificationEnabled ?? this.fajrNotificationEnabled,
    dhuhrNotificationEnabled: dhuhrNotificationEnabled ?? this.dhuhrNotificationEnabled,
    asrNotificationEnabled: asrNotificationEnabled ?? this.asrNotificationEnabled,
    maghribNotificationEnabled: maghribNotificationEnabled ?? this.maghribNotificationEnabled,
    ishaNotificationEnabled: ishaNotificationEnabled ?? this.ishaNotificationEnabled,
    useAdhan: useAdhan ?? this.useAdhan,
  );
}