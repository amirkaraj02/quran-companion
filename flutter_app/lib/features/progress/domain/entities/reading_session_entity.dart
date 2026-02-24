import 'package:equatable/equatable.dart';

class ReadingSessionEntity extends Equatable {
  final String id;
  final String goalId;
  final DateTime date;
  final int pagesRead;
  final int ayahsRead;
  final int startPage;
  final int endPage;
  final int durationMinutes;

  const ReadingSessionEntity({
    required this.id,
    required this.goalId,
    required this.date,
    required this.pagesRead,
    required this.ayahsRead,
    required this.startPage,
    required this.endPage,
    required this.durationMinutes,
  });

  @override
  List<Object?> get props => [id];
}