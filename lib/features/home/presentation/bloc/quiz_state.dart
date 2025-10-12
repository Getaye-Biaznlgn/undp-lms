import 'package:equatable/equatable.dart';
import 'package:lms/features/home/data/models/quiz_model.dart';
import 'package:lms/features/home/data/models/quiz_detail_model.dart';
import 'package:lms/features/home/data/models/quiz_result_model.dart';
import 'package:lms/features/home/data/models/quiz_submission_result_model.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitialState extends QuizState {}

class QuizLoadingState extends QuizState {}

class QuizListLoadedState extends QuizState {
  final List<QuizModel> quizzes;

  const QuizListLoadedState({required this.quizzes});

  @override
  List<Object?> get props => [quizzes];
}

class QuizDetailLoadedState extends QuizState {
  final QuizDetailModel quizDetail;

  const QuizDetailLoadedState({required this.quizDetail});

  @override
  List<Object?> get props => [quizDetail];
}

class QuizSubmittedState extends QuizState {
  final QuizSubmissionResultModel result;

  const QuizSubmittedState({required this.result});

  @override
  List<Object?> get props => [result];
}

class QuizResultsLoadedState extends QuizState {
  final List<QuizResultModel> results;

  const QuizResultsLoadedState({required this.results});

  @override
  List<Object?> get props => [results];
}

class QuizErrorState extends QuizState {
  final String message;

  const QuizErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
