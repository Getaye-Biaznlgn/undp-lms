class QuizSubmissionResultModel {
  final int quizId;
  final int score;
  final int totalMark;
  final QuizSubmissionInfo results;

  QuizSubmissionResultModel({
    required this.quizId,
    required this.score,
    required this.totalMark,
    required this.results,
  });

  factory QuizSubmissionResultModel.fromJson(Map<String, dynamic> json) {
    return QuizSubmissionResultModel(
      quizId: json['quiz_id'] ?? 0,
      score: json['score'] ?? 0,
      totalMark: json['total_mark'] ?? 0,
      results: QuizSubmissionInfo.fromJson(json['results'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_id': quizId,
      'score': score,
      'total_mark': totalMark,
      'results': results.toJson(),
    };
  }

  double get percentage => totalMark > 0 ? (score / totalMark * 100) : 0;
  bool isPassed(int passMark) => percentage >= passMark;
}

class QuizSubmissionInfo {
  final int id;
  final int quizId;
  final int userId;
  final String createdAt;
  final String updatedAt;

  QuizSubmissionInfo({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuizSubmissionInfo.fromJson(Map<String, dynamic> json) {
    return QuizSubmissionInfo(
      id: json['id'] ?? 0,
      quizId: json['quiz_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
