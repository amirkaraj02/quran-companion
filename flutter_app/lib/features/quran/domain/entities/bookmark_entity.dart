import 'package:equatable/equatable.dart';

class BookmarkEntity extends Equatable {
  final String id;
  final int surahNumber;
  final int ayahNumber;
  final int pageNumber;
  final String? note;
  final DateTime createdAt;

  const BookmarkEntity({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.pageNumber,
    this.note,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}