import 'package:equatable/equatable.dart';

enum TajweedRule {
  none, ghunna, madd, qalqalah, ikhfa, idgham, iqlab, izhaar
}

class TajweedSegment {
  final int start;
  final int end;
  final TajweedRule rule;
  const TajweedSegment({required this.start, required this.end, required this.rule});
}

class AyahEntity extends Equatable {
  final int surahNumber;
  final int ayahNumber;
  final int pageNumber;
  final int juzNumber;
  final int hizbNumber;
  final String textArabic;
  final String textUthmani;
  final String translationAlbanian;
  final String translationEnglish;
  final String translationTurkish;
  final List<TajweedSegment> tajweedSegments;
  final bool isSajdah;

  const AyahEntity({
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
    this.tajweedSegments = const [],
    this.isSajdah = false,
  });

  String translation(String langCode) {
    switch (langCode) {
      case 'sq': return translationAlbanian;
      case 'tr': return translationTurkish;
      default: return translationEnglish;
    }
  }

  @override
  List<Object?> get props => [surahNumber, ayahNumber];
}