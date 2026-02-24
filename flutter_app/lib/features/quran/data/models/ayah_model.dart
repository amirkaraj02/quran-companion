import 'package:hive/hive.dart';
import '../../domain/entities/ayah_entity.dart';


@HiveType(typeId: 2)
class AyahModel extends HiveObject {
  @HiveField(0) final int surahNumber;
  @HiveField(1) final int ayahNumber;
  @HiveField(2) final int pageNumber;
  @HiveField(3) final int juzNumber;
  @HiveField(4) final int hizbNumber;
  @HiveField(5) final String textArabic;
  @HiveField(6) final String textUthmani;
  @HiveField(7) final String translationAlbanian;
  @HiveField(8) final String translationEnglish;
  @HiveField(9) final String translationTurkish;
  @HiveField(10) final bool isSajdah;

  AyahModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.pageNumber,
    required this.juzNumber,
    required this.hizbNumber,
    required this.textArabic,
    required this.textUthmani,
    this.translationAlbanian = '',
    this.translationEnglish = '',
    this.translationTurkish = '',
    this.isSajdah = false,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) => AyahModel(
    surahNumber: json['surahNumber'] as int? ?? json['chapter'] as int? ?? 1,
    ayahNumber: json['numberInSurah'] as int? ?? json['verse'] as int? ?? 1,
    pageNumber: json['page'] as int? ?? 1,
    juzNumber: json['juz'] as int? ?? 1,
    hizbNumber: json['hizb'] as int? ?? 1,
    textArabic: json['text'] as String? ?? json['textArabic'] as String? ?? '',
    textUthmani: json['textUthmani'] as String? ?? json['text'] as String? ?? '',
    translationAlbanian: json['translationAlbanian'] as String? ?? '',
    translationEnglish: json['translationEnglish'] as String? ?? '',
    translationTurkish: json['translationTurkish'] as String? ?? '',
    isSajdah: json['sajda'] as bool? ?? false,
  );

  AyahEntity toEntity() => AyahEntity(
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
    pageNumber: pageNumber,
    juzNumber: juzNumber,
    hizbNumber: hizbNumber,
    textArabic: textArabic,
    textUthmani: textUthmani,
    translationAlbanian: translationAlbanian,
    translationEnglish: translationEnglish,
    translationTurkish: translationTurkish,
    isSajdah: isSajdah,
  );
}