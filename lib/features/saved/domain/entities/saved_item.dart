import 'package:equatable/equatable.dart';

class SavedItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String type; // 'course', 'article', 'video', etc.
  final String imageUrl;
  final DateTime savedAt;
  final String? courseId; // if it's a course item

  const SavedItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.imageUrl,
    required this.savedAt,
    this.courseId,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        imageUrl,
        savedAt,
        courseId,
      ];
}
