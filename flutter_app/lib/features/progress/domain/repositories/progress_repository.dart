import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reading_goal_entity.dart';
import '../entities/reading_session_entity.dart';

abstract class ProgressRepository {
  Future<Either<Failure, List<ReadingGoalEntity>>> getGoals();
  Future<Either<Failure, ReadingGoalEntity?>> getActiveGoal();
  Future<Either<Failure, void>> createGoal(ReadingGoalEntity goal);
  Future<Either<Failure, void>> updateGoal(ReadingGoalEntity goal);
  Future<Either<Failure, void>> deleteGoal(String id);
  Future<Either<Failure, List<ReadingSessionEntity>>> getSessions(String goalId);
  Future<Either<Failure, void>> logSession(ReadingSessionEntity session);
  Future<Either<Failure, Map<String, int>>> getWeeklyStats();
  Future<Either<Failure, int>> getTodayPagesRead();
}