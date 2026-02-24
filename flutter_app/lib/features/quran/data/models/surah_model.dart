import 'package:hive/hive.dart';
import '../../domain/entities/surah_entity.dart';


@HiveType(typeId: 1)
class SurahModel extends HiveObject {
  @HiveField(0) final int number;
  @HiveField(1) final String nameArabic;
  @HiveField(2) final String nameTransliteration;
  @HiveField(3) final String nameAlbanian;
  @HiveField(4) final String nameEnglish;
  @HiveField(5) final String nameTurkish;
  @HiveField(6) final String revelationType;
  @HiveField(7) final int ayahCount;
  @HiveField(8) final int startPage;
  @HiveField(9) final int juz;
  @HiveField(10) final String audioUrl;

  SurahModel({
    required this.number,
    required this.nameArabic,
    required this.nameTransliteration,
    required this.nameAlbanian,
    required this.nameEnglish,
    required this.nameTurkish,
    required this.revelationType,
    required this.ayahCount,
    required this.startPage,
    required this.juz,
    this.audioUrl = '',
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) => SurahModel(
    number: json['number'] as int,
    nameArabic: json['nameArabic'] as String? ?? '',
    nameTransliteration: json['nameTransliteration'] as String? ?? '',
    nameAlbanian: json['nameAlbanian'] as String? ?? '',
    nameEnglish: json['nameEnglish'] as String? ?? json['englishName'] as String? ?? '',
    nameTurkish: json['nameTurkish'] as String? ?? '',
    revelationType: json['revelationType'] as String? ?? 'Meccan',
    ayahCount: (json['numberOfAyahs'] ?? json['ayahCount'] ?? 0) as int,
    startPage: json['startPage'] as int? ?? 1,
    juz: json['juz'] as int? ?? 1,
    audioUrl: json['audioUrl'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'number': number,
    'nameArabic': nameArabic,
    'nameTransliteration': nameTransliteration,
    'nameAlbanian': nameAlbanian,
    'nameEnglish': nameEnglish,
    'nameTurkish': nameTurkish,
    'revelationType': revelationType,
    'numberOfAyahs': ayahCount,
    'startPage': startPage,
    'juz': juz,
    'audioUrl': audioUrl,
  };

  SurahEntity toEntity() => SurahEntity(
    number: number,
    nameArabic: nameArabic,
    nameTransliteration: nameTransliteration,
    nameAlbanian: nameAlbanian,
    nameEnglish: nameEnglish,
    nameTurkish: nameTurkish,
    revelationType: revelationType,
    ayahCount: ayahCount,
    startPage: startPage,
    juz: juz,
    audioUrl: audioUrl,
  );

  static SurahModel fromEntity(SurahEntity e) => SurahModel(
    number: e.number,
    nameArabic: e.nameArabic,
    nameTransliteration: e.nameTransliteration,
    nameAlbanian: e.nameAlbanian,
    nameEnglish: e.nameEnglish,
    nameTurkish: e.nameTurkish,
    revelationType: e.revelationType,
    ayahCount: e.ayahCount,
    startPage: e.startPage,
    juz: e.juz,
    audioUrl: e.audioUrl,
  );
}