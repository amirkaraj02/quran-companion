import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/entities/reading_goal_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import 'package:uuid/uuid.dart';

final progressRepositoryProvider = Provider<ProgressRepository>(
  (_) => ProgressRepositoryImpl(),
);

final activeGoalProvider = FutureProvider<ReadingGoalEntity?>((ref) async {
  final repo = ref.read(progressRepositoryProvider);
  final result = await repo.getActiveGoal();
  return result.fold((_) => null, (g) => g);
});

final allGoalsProvider = FutureProvider<List<ReadingGoalEntity>>((ref) async {
  final repo = ref.read(progressRepositoryProvider);
  final result = await repo.getGoals();
  return result.fold((_) => [], (g) => g);
});

final weeklyStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repo = ref.read(progressRepositoryProvider);
  final result = await repo.getWeeklyStats();
  return result.fold((_) => {}, (s) => s);
});

final todayPagesProvider = FutureProvider<int>((ref) async {
  final repo = ref.read(progressRepositoryProvider);
  final result = await repo.getTodayPagesRead();
  return result.fold((_) => 0, (p) => p);
});

class GoalCreationNotifier extends StateNotifier<AsyncValue<void>> {
  final ProgressRepository _repository;
  GoalCreationNotifier(this._repository) : super(const AsyncData(null));

  Future<void> createHatimGoal({required int days}) async {
    state = const AsyncLoading();
    final goal = ReadingGoalEntity(
      id: const Uuid().v4(),
      type: GoalType.hatim,
      title: 'Hatim in $days days',
      targetDays: days,
      targetPagesPerDay: (604 / days).ceil(),
      startDate: DateTime.now(),
    );
    final result = await _repository.createGoal(goal);
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  Future<void> createDailyGoal({required int pagesPerDay}) async {
    state = const AsyncLoading();
    final daysToFinish = (604 / pagesPerDay).ceil();
    final goal = ReadingGoalEntity(
      id: const Uuid().v4(),
      type: GoalType.dailyReading,
      title: '$pagesPerDay pages/day',
      targetDays: daysToFinish,
      targetPagesPerDay: pagesPerDay,
      startDate: DateTime.now(),
    );
    final result = await _repository.createGoal(goal);
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}

final goalCreationProvider =
    StateNotifierProvider<GoalCreationNotifier, AsyncValue<void>>(
  (ref) => GoalCreationNotifier(ref.read(progressRepositoryProvider)),
);