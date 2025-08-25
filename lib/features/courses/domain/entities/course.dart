import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String imageUrl;
  final double rating;
  final int enrolledStudents;
  final String duration;
  final String level;
  final List<String> tags;
  final bool isEnrolled;
  final bool isCompleted;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.imageUrl,
    required this.rating,
    required this.enrolledStudents,
    required this.duration,
    required this.level,
    required this.tags,
    this.isEnrolled = false,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        instructor,
        imageUrl,
        rating,
        enrolledStudents,
        duration,
        level,
        tags,
        isEnrolled,
        isCompleted,
      ];
}
