import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final String role; // 'student', 'instructor', 'admin'
  final DateTime joinedAt;
  final int completedCourses;
  final int enrolledCourses;
  final double averageScore;
  final List<String> achievements;
  final Map<String, dynamic> preferences;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.bio,
    required this.role,
    required this.joinedAt,
    required this.completedCourses,
    required this.enrolledCourses,
    required this.averageScore,
    required this.achievements,
    required this.preferences,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        bio,
        role,
        joinedAt,
        completedCourses,
        enrolledCourses,
        averageScore,
        achievements,
        preferences,
      ];
}
