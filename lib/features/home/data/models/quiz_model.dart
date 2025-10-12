class QuizListModel {
  final List<QuizModel> quizzes;

  QuizListModel({required this.quizzes});

  factory QuizListModel.fromJson(Map<String, dynamic> json) {
    return QuizListModel(
      quizzes: (json['quizzes'] as List<dynamic>?)
              ?.map((quiz) => QuizModel.fromJson(quiz))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizzes': quizzes.map((quiz) => quiz.toJson()).toList(),
    };
  }
}

class QuizModel {
  final int id;
  final int chapterItemId;
  final int instructorId;
  final int chapterId;
  final int courseId;
  final String title;
  final String time;
  final String attempt;
  final String passMark;
  final String totalMark;
  final String status;
  final String createdAt;
  final String updatedAt;

  QuizModel({
    required this.id,
    required this.chapterItemId,
    required this.instructorId,
    required this.chapterId,
    required this.courseId,
    required this.title,
    required this.time,
    required this.attempt,
    required this.passMark,
    required this.totalMark,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] ?? 0,
      chapterItemId: json['chapter_item_id'] ?? 0,
      instructorId: json['instructor_id'] ?? 0,
      chapterId: json['chapter_id'] ?? 0,
      courseId: json['course_id'] ?? 0,
      title: json['title'] ?? '',
      time: json['time']?.toString() ?? '',
      attempt: json['attempt']?.toString() ?? '',
      passMark: json['pass_mark']?.toString() ?? '',
      totalMark: json['total_mark']?.toString() ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter_item_id': chapterItemId,
      'instructor_id': instructorId,
      'chapter_id': chapterId,
      'course_id': courseId,
      'title': title,
      'time': time,
      'attempt': attempt,
      'pass_mark': passMark,
      'total_mark': totalMark,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
