class QuizResultListModel {
  final List<QuizResultModel> results;

  QuizResultListModel({required this.results});

  factory QuizResultListModel.fromJson(Map<String, dynamic> json) {
    return QuizResultListModel(
      results: (json['results'] as List<dynamic>?)
              ?.map((result) => QuizResultModel.fromJson(result))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((result) => result.toJson()).toList(),
    };
  }
}

class QuizResultModel {
  final int id;
  final String userId;
  final String quizId;
  final List<dynamic> result;
  final int userGrade;
  final String status;
  final String createdAt;
  final String updatedAt;
  final QuizResultInfo quiz;

  QuizResultModel({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.result,
    required this.userGrade,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.quiz,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      quizId: json['quiz_id']?.toString() ?? '',
      result: json['result'] ?? [],
      userGrade: json['user_grade'] ?? 0,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      quiz: QuizResultInfo.fromJson(json['quiz'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'quiz_id': quizId,
      'result': result,
      'user_grade': userGrade,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'quiz': quiz.toJson(),
    };
  }
}

class QuizResultInfo {
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

  QuizResultInfo({
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

  factory QuizResultInfo.fromJson(Map<String, dynamic> json) {
    return QuizResultInfo(
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
