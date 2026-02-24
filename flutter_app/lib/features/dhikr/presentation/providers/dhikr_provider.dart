import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/dhikr_entity.dart';

// Default dhikr presets
final defaultDhikrList = [
  const DhikrEntity(
    id: 'subhanallah',
    textArabic: 'سُبْحَانَ اللّهِ',
    textAlbanian: 'I Lartësuar qoftë Allahu',
    textEnglish: 'Glory be to Allah',
    textTurkish: 'Allah'ı tenzih ederim',
    targetCount: 33,
    category: 'general',
  ),
  const DhikrEntity(
    id: 'alhamdulillah',
    textArabic: 'الْحَمْدُ لِلَّهِ',
    textAlbanian: 'Falënderimi i takon Allahut',
    textEnglish: 'All praise is due to Allah',
    textTurkish: 'Hamd Allah'a aittir',
    targetCount: 33,
    category: 'general',
  ),
  const DhikrEntity(
    id: 'allahuakbar',
    textArabic: 'اللَّهُ أَكْبَرُ',
    textAlbanian: 'Allahu është më i Madhi',
    textEnglish: 'Allah is the Greatest',
    textTurkish: 'Allah en büyüktür',
    targetCount: 34,
    category: 'general',
  ),
  const DhikrEntity(
    id: 'lailahaillallah',
    textArabic: 'لَا إِلَهَ إِلَّا اللَّهُ',
    textAlbanian: 'Nuk ka të adhuruar tjetër me të drejtë pos Allahut',
    textEnglish: 'There is no god but Allah',
    textTurkish: 'Allah'tan başka ilah yoktur',
    targetCount: 100,
    category: 'general',
  ),
  const DhikrEntity(
    id: 'astaghfirullah',
    textArabic: 'أَسْتَغْفِرُ اللَّهَ',
    textAlbanian: 'Kërkoj falje nga Allahu',
    textEnglish: 'I seek forgiveness from Allah',
    textTurkish: 'Allah'tan bağışlanma dilerim',
    targetCount: 100,
    category: 'general',
  ),
  const DhikrEntity(
    id: 'salawat',
    textArabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
    textAlbanian: 'O Allah, dërgoi salavate Muhamedit',
    textEnglish: 'O Allah, send blessings upon Muhammad',
    textTurkish: 'Allah'ım, Muhammed'e salat eyle',
    targetCount: 100,
    category: 'general',
  ),
];

// Counter state per dhikr ID
class DhikrCountState {
  final Map<String, int> counts;
  final String activeDhikrId;

  const DhikrCountState({
    required this.counts,
    required this.activeDhikrId,
  });

  DhikrCountState copyWith({Map<String, int>? counts, String? activeDhikrId}) =>
      DhikrCountState(
        counts: counts ?? this.counts,
        activeDhikrId: activeDhikrId ?? this.activeDhikrId,
      );

  int getCount(String id) => counts[id] ?? 0;
}

class DhikrCountNotifier extends StateNotifier<DhikrCountState> {
  DhikrCountNotifier() : super(DhikrCountState(
    counts: {},
    activeDhikrId: defaultDhikrList.first.id,
  ));

  void increment(String id) {
    final newCounts = Map<String, int>.from(state.counts);
    newCounts[id] = (newCounts[id] ?? 0) + 1;
    state = state.copyWith(counts: newCounts);
  }

  void reset(String id) {
    final newCounts = Map<String, int>.from(state.counts);
    newCounts[id] = 0;
    state = state.copyWith(counts: newCounts);
  }

  void setActive(String id) {
    state = state.copyWith(activeDhikrId: id);
  }
}

final dhikrCountProvider =
    StateNotifierProvider<DhikrCountNotifier, DhikrCountState>(
  (_) => DhikrCountNotifier(),
);