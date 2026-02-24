import 'package:hive/hive.dart';
import '../../domain/entities/reading_goal_entity.dart';

part 'reading_goal_model.g.dart';

@HiveType(typeId: 10)
class ReadingGoalModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final int type;
  @HiveField(2) final String title;
  @HiveField(3) final int targetDays;
  @HiveField(4) final int targetPagesPerDay;
  @HiveField(5) int totalPagesRead;
  @HiveField(6) int currentStreak;
  @HiveField(7) int longestStreak;
  @HiveField(8) final String startDate;
  @HiveField(9) String? completedDate;
  @HiveField(10) bool isActive;
  @HiveField(11) final int reminderHour;
  @HiveField(12) final int reminderMinute;

  ReadingGoalModel({
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

  factory ReadingGoalModel.fromJson(Map<String, dynamic> j) => ReadingGoalModel(
    id: j['id'] as String,
    type: j['type'] as int,
    title: j['title'] as String,
    targetDays: j['targetDays'] as int,
    targetPagesPerDay: j['targetPagesPerDay'] as int,
    totalPagesRead: j['totalPagesRead'] as int? ?? 0,
    currentStreak: j['currentStreak'] as int? ?? 0,
    longestStreak: j['longestStreak'] as int? ?? 0,
    startDate: j['startDate'] as String,
    completedDate: j['completedDate'] as String?,
    isActive: j['isActive'] as bool? ?? true,
    reminderHour: j['reminderHour'] as int? ?? 7,
    reminderMinute: j['reminderMinute'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'type': type, 'title': title,
    'targetDays': targetDays, 'targetPagesPerDay': targetPagesPerDay,
    'totalPagesRead': totalPagesRead, 'currentStreak': currentStreak,
    'longestStreak': longestStreak, 'startDate': startDate,
    'completedDate': completedDate, 'isActive': isActive,
    'reminderHour': reminderHour, 'reminderMinute': reminderMinute,
  };

  ReadingGoalEntity toEntity() => ReadingGoalEntity(
    id: id, type: GoalType.values[type], title: title,
    targetDays: targetDays, targetPagesPerDay: targetPagesPerDay,
    totalPagesRead: totalPagesRead, currentStreak: currentStreak,
    longestStreak: longestStreak, startDate: DateTime.parse(startDate),
    completedDate: completedDate != null ? DateTime.parse(completedDate!) : null,
    isActive: isActive, reminderHour: reminderHour, reminderMinute: reminderMinute,
  );

  static ReadingGoalModel fromEntity(ReadingGoalEntity e) => ReadingGoalModel(
    id: e.id, type: e.type.index, title: e.title,
    targetDays: e.targetDays, targetPagesPerDay: e.targetPagesPerDay,
    totalPagesRead: e.totalPagesRead, currentStreak: e.currentStreak,
    longestStreak: e.longestStreak, startDate: e.startDate.toIso8601String(),
    completedDate: e.completedDate?.toIso8601String(),
    isActive: e.isActive, reminderHour: e.reminderHour, reminderMinute: e.reminderMinute,
  );
}