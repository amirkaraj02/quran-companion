import 'package:hive/hive.dart';
import '../../domain/entities/bookmark_entity.dart';

part 'bookmark_model.g.dart';

@HiveType(typeId: 3)
class BookmarkModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final int surahNumber;
  @HiveField(2) final int ayahNumber;
  @HiveField(3) final int pageNumber;
  @HiveField(4) final String? note;
  @HiveField(5) final DateTime createdAt;

  BookmarkModel({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.pageNumber,
    this.note,
    required this.createdAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
    id: json['id'] as String,
    surahNumber: json['surahNumber'] as int,
    ayahNumber: json['ayahNumber'] as int,
    pageNumber: json['pageNumber'] as int,
    note: json['note'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'surahNumber': surahNumber, 'ayahNumber': ayahNumber,
    'pageNumber': pageNumber, 'note': note, 'createdAt': createdAt.toIso8601String(),
  };

  BookmarkEntity toEntity() => BookmarkEntity(
    id: id, surahNumber: surahNumber, ayahNumber: ayahNumber,
    pageNumber: pageNumber, note: note, createdAt: createdAt,
  );

  static BookmarkModel fromEntity(BookmarkEntity e) => BookmarkModel(
    id: e.id, surahNumber: e.surahNumber, ayahNumber: e.ayahNumber,
    pageNumber: e.pageNumber, note: e.note, createdAt: e.createdAt,
  );
}