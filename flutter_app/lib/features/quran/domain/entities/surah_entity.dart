import 'package:equatable/equatable.dart';

class SurahEntity extends Equatable {
  final int number;
  final String nameArabic;
  final String nameTransliteration;
  final String nameAlbanian;
  final String nameEnglish;
  final String nameTurkish;
  final String revelationType; // 'Meccan' or 'Medinan'
  final int ayahCount;
  final int startPage;
  final int juz;
  final String audioUrl;

  const SurahEntity({
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

  String localizedName(String langCode) {
    switch (langCode) {
      case 'sq': return nameAlbanian;
      case 'tr': return nameTurkish;
      default: return nameEnglish;
    }
  }

  @override
  List<Object?> get props => [number];
}