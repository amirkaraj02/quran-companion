import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bookmark_entity.dart';
import '../repositories/quran_repository.dart';

class GetBookmarks implements UseCase<List<BookmarkEntity>, NoParams> {
  final QuranRepository _repository;
  const GetBookmarks(this._repository);
  @override
  Future<Either<Failure, List<BookmarkEntity>>> call(NoParams _) =>
      _repository.getBookmarks();
}

class AddBookmark implements UseCase<void, BookmarkEntity> {
  final QuranRepository _repository;
  const AddBookmark(this._repository);
  @override
  Future<Either<Failure, void>> call(BookmarkEntity b) => _repository.addBookmark(b);
}

class RemoveBookmark implements UseCase<void, String> {
  final QuranRepository _repository;
  const RemoveBookmark(this._repository);
  @override
  Future<Either<Failure, void>> call(String id) => _repository.removeBookmark(id);
}