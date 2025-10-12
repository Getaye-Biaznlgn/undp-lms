import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class GetQuizzesByCourseIdEvent extends QuizEvent {
  final String courseId;

  const GetQuizzesByCourseIdEvent({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

class GetQuizDetailEvent extends QuizEvent {
  final int quizId;

  const GetQuizDetailEvent({required this.quizId});

  @override
  List<Object?> get props => [quizId];
}

class SubmitQuizEvent extends QuizEvent {
  final int quizId;
  final int userId;
  final Map<int, int> answers; // question_id -> answer_id

  const SubmitQuizEvent({
    required this.quizId,
    required this.userId,
    required this.answers,
  });

  @override
  List<Object?> get props => [quizId, userId, answers];
}

class GetQuizResultsEvent extends QuizEvent {
  final int userId;

  const GetQuizResultsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ResetQuizStateEvent extends QuizEvent {
  const ResetQuizStateEvent();
}
