class EnrolledCourseModel {
  final String slug;
  final String title;
  final String thumbnail;
  final EnrolledInstructor instructor;
  final int students;
  final int progress;

  EnrolledCourseModel({
    required this.slug,
    required this.title,
    required this.thumbnail,
    required this.instructor,
    required this.students,
    required this.progress,
  });

  factory EnrolledCourseModel.fromJson(Map<String, dynamic> json) {
    return EnrolledCourseModel(
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      instructor: EnrolledInstructor.fromJson(json['instructor'] ?? {}),
      students: json['students'] ?? 0,
      progress: json['progress'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'title': title,
      'thumbnail': thumbnail,
      'instructor': instructor.toJson(),
      'students': students,
      'progress': progress,
    };
  }
}

class EnrolledInstructor {
  final int id;
  final String name;
  final String image;

  EnrolledInstructor({
    required this.id,
    required this.name,
    required this.image,
  });

  factory EnrolledInstructor.fromJson(Map<String, dynamic> json) {
    return EnrolledInstructor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
