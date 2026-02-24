import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ayah_entity.dart';
import '../repositories/quran_repository.dart';

class GetAyahsBySurah implements UseCase<List<AyahEntity>, int> {
  final QuranRepository _repository;
  const GetAyahsBySurah(this._repository);

  @override
  Future<Either<Failure, List<AyahEntity>>> call(int surahNumber) =>
      _repository.getAyahsBySurah(surahNumber);
}