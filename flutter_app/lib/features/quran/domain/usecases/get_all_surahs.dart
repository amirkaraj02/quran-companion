import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/surah_entity.dart';
import '../repositories/quran_repository.dart';

class GetAllSurahs implements UseCase<List<SurahEntity>, NoParams> {
  final QuranRepository _repository;
  const GetAllSurahs(this._repository);

  @override
  Future<Either<Failure, List<SurahEntity>>> call(NoParams params) =>
      _repository.getAllSurahs();
}