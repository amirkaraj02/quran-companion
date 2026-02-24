import 'package:equatable/equatable.dart';

class DhikrEntity extends Equatable {
  final String id;
  final String textArabic;
  final String textAlbanian;
  final String textEnglish;
  final String textTurkish;
  final int targetCount;
  final int currentCount;
  final String category; // morning, evening, general

  const DhikrEntity({
    required this.id,
    required this.textArabic,
    required this.textAlbanian,
    required this.textEnglish,
    required this.textTurkish,
    required this.targetCount,
    this.currentCount = 0,
    required this.category,
  });

  bool get isCompleted => currentCount >= targetCount;

  DhikrEntity copyWith({int? currentCount}) => DhikrEntity(
    id: id,
    textArabic: textArabic,
    textAlbanian: textAlbanian,
    textEnglish: textEnglish,
    textTurkish: textTurkish,
    targetCount: targetCount,
    currentCount: currentCount ?? this.currentCount,
    category: category,
  );

  String localizedText(String langCode) {
    switch (langCode) {
      case 'sq': return textAlbanian;
      case 'tr': return textTurkish;
      default: return textEnglish;
    }
  }

  @override
  List<Object?> get props => [id];
}