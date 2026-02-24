import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ayah_entity.dart';
import '../repositories/quran_repository.dart';

class SearchAyahs implements UseCase<List<AyahEntity>, String> {
  final QuranRepository _repository;
  const SearchAyahs(this._repository);
  @override
  Future<Either<Failure, List<AyahEntity>>> call(String query) =>
      _repository.searchAyahs(query);
}