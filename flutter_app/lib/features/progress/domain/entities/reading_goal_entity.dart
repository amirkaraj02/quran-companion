import 'package:equatable/equatable.dart';

enum GoalType { hatim, dailyReading, memorization, learning }

class ReadingGoalEntity extends Equatable {
  final String id;
  final GoalType type;
  final String title;
  final int targetDays;
  final int targetPagesPerDay;
  final int totalPagesRead;
  final int currentStreak;
  final int longestStreak;
  final DateTime startDate;
  final DateTime? completedDate;
  final bool isActive;
  final int reminderHour;
  final int reminderMinute;

  const ReadingGoalEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.targetDays,
    required this.targetPagesPerDay,
    this.totalPagesRead = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.startDate,
    this.completedDate,
    this.isActive = true,
    this.reminderHour = 7,
    this.reminderMinute = 0,
  });

  double get completionPercentage =>
      (totalPagesRead / (targetDays * targetPagesPerDay)).clamp(0.0, 1.0);

  int get remainingPages =>
      (targetDays * targetPagesPerDay - totalPagesRead).clamp(0, 999999);

  DateTime get estimatedFinishDate =>
      startDate.add(Duration(days: targetDays));

  int get daysElapsed => DateTime.now().difference(startDate).inDays;

  int get daysRemaining => (targetDays - daysElapsed).clamp(0, targetDays);

  bool get isOnTrack {
    final expectedPages = daysElapsed * targetPagesPerDay;
    return totalPagesRead >= expectedPages;
  }

  @override
  List<Object?> get props => [id];
}