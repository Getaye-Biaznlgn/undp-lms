class QuizDetailModel {
  final QuizDetailInfo quiz;

  QuizDetailModel({required this.quiz});

  factory QuizDetailModel.fromJson(Map<String, dynamic> json) {
    return QuizDetailModel(
      quiz: QuizDetailInfo.fromJson(json['quiz'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz': quiz.toJson(),
    };
  }
}

class QuizDetailInfo {
  final int id;
  final String title;
  final String time;
  final String attempt;
  final String passMark;
  final String totalMark;
  final List<QuestionModel> questions;

  QuizDetailInfo({
    required this.id,
    required this.title,
    required this.time,
    required this.attempt,
    required this.passMark,
    required this.totalMark,
    required this.questions,
  });

  factory QuizDetailInfo.fromJson(Map<String, dynamic> json) {
    return QuizDetailInfo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      time: json['time']?.toString() ?? '',
      attempt: json['attempt']?.toString() ?? '',
      passMark: json['pass_mark']?.toString() ?? '',
      totalMark: json['total_mark']?.toString() ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((question) => QuestionModel.fromJson(question))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'attempt': attempt,
      'pass_mark': passMark,
      'total_mark': totalMark,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}

class QuestionModel {
  final int id;
  final String question;
  final String type;
  final dynamic mark;
  final List<AnswerModel> answers;

  QuestionModel({
    required this.id,
    required this.question,
    required this.type,
    this.mark,
    required this.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      type: json['type'] ?? '',
      mark: json['mark'],
      answers: (json['answers'] as List<dynamic>?)
              ?.map((answer) => AnswerModel.fromJson(answer))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type,
      'mark': mark,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

class AnswerModel {
  final int id;
  final String text;
  final String isCorrect;

  AnswerModel({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      isCorrect: json['is_correct']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'is_correct': isCorrect,
    };
  }
}
