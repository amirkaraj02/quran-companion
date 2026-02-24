import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/reading_goal_entity.dart';
import '../../domain/entities/reading_session_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../models/reading_goal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  Box get _goalsBox => Hive.box(AppConstants.boxReadingGoals);
  Box get _sessionsBox => Hive.box(AppConstants.boxReadingSessions);

  @override
  Future<Either<Failure, List<ReadingGoalEntity>>> getGoals() async {
    try {
      final goals = _goalsBox.values
          .whereType<Map>()
          .map((m) => ReadingGoalModel.fromJson(Map<String, dynamic>.from(m)).toEntity())
          .toList();
      return Right(goals);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReadingGoalEntity?>> getActiveGoal() async {
    final result = await getGoals();
    return result.map((goals) =>
      goals.where((g) => g.isActive).isNotEmpty
          ? goals.firstWhere((g) => g.isActive)
          : null,
    );
  }

  @override
  Future<Either<Failure, void>> createGoal(ReadingGoalEntity goal) async {
    try {
      await _goalsBox.put(goal.id, ReadingGoalModel.fromEntity(goal).toJson());
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateGoal(ReadingGoalEntity goal) async {
    try {
      await _goalsBox.put(goal.id, ReadingGoalModel.fromEntity(goal).toJson());
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoal(String id) async {
    try {
      await _goalsBox.delete(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReadingSessionEntity>>> getSessions(String goalId) async {
    try {
      final sessions = _sessionsBox.values
          .whereType<Map>()
          .where((m) => m['goalId'] == goalId)
          .map((m) {
            final j = Map<String, dynamic>.from(m);
            return ReadingSessionEntity(
              id: j['id'] as String,
              goalId: j['goalId'] as String,
              date: DateTime.parse(j['date'] as String),
              pagesRead: j['pagesRead'] as int,
              ayahsRead: j['ayahsRead'] as int,
              startPage: j['startPage'] as int,
              endPage: j['endPage'] as int,
              durationMinutes: j['durationMinutes'] as int,
            );
          })
          .toList();
      return Right(sessions);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logSession(ReadingSessionEntity session) async {
    try {
      await _sessionsBox.put(session.id, {
        'id': session.id, 'goalId': session.goalId,
        'date': session.date.toIso8601String(), 'pagesRead': session.pagesRead,
        'ayahsRead': session.ayahsRead, 'startPage': session.startPage,
        'endPage': session.endPage, 'durationMinutes': session.durationMinutes,
      });
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getWeeklyStats() async {
    try {
      final now = DateTime.now();
      final stats = <String, int>{};
      for (int i = 6; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        final key = '${day.month}-${day.day}';
        final pages = _sessionsBox.values
            .whereType<Map>()
            .where((m) {
              final d = DateTime.tryParse(m['date'] as String? ?? '');
              return d != null && d.day == day.day && d.month == day.month;
            })
            .fold<int>(0, (sum, m) => sum + (m['pagesRead'] as int? ?? 0));
        stats[key] = pages;
      }
      return Right(stats);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTodayPagesRead() async {
    try {
      final today = DateTime.now();
      final pages = _sessionsBox.values
          .whereType<Map>()
          .where((m) {
            final d = DateTime.tryParse(m['date'] as String? ?? '');
            return d != null && d.day == today.day && d.month == today.month;
          })
          .fold<int>(0, (sum, m) => sum + (m['pagesRead'] as int? ?? 0));
      return Right(pages);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}