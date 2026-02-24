class ReadingPositionEntity {
  final int pageNumber;
  final int surahNumber;
  final int ayahNumber;
  final DateTime lastRead;

  const ReadingPositionEntity({
    required this.pageNumber,
    required this.surahNumber,
    required this.ayahNumber,
    required this.lastRead,
  });
}