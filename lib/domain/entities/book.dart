import 'book_format.dart';

class Book {
  final String id;
  final String title;
  final BookFormat format;
  final String filePath;
  final String? coverPath;
  final String? shelfId;
  final DateTime addedAt;
  final DateTime? lastOpenedAt;

  const Book({
    required this.id,
    required this.title,
    required this.format,
    required this.filePath,
    this.coverPath,
    this.shelfId,
    required this.addedAt,
    this.lastOpenedAt,
  });
}
