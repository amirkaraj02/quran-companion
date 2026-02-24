import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reading_position_entity.dart';
import '../repositories/quran_repository.dart';

class SaveLastPosition implements UseCase<void, ReadingPositionEntity> {
  final QuranRepository _repository;
  const SaveLastPosition(this._repository);

  @override
  Future<Either<Failure, void>> call(ReadingPositionEntity position) =>
      _repository.saveLastPosition(position);
}