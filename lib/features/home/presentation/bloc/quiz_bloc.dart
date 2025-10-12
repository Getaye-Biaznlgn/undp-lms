import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/home/domain/usecases/get_quizzes_by_course_id_usecase.dart';
import 'package:lms/features/home/domain/usecases/get_quiz_detail_usecase.dart';
import 'package:lms/features/home/domain/usecases/submit_quiz_usecase.dart';
import 'package:lms/features/home/domain/usecases/get_quiz_results_usecase.dart';
import 'package:lms/features/home/presentation/bloc/quiz_event.dart';
import 'package:lms/features/home/presentation/bloc/quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetQuizzesByCourseIdUseCase getQuizzesByCourseIdUseCase;
  final GetQuizDetailUseCase getQuizDetailUseCase;
  final SubmitQuizUseCase submitQuizUseCase;
  final GetQuizResultsUseCase getQuizResultsUseCase;

  QuizBloc({
    required this.getQuizzesByCourseIdUseCase,
    required this.getQuizDetailUseCase,
    required this.submitQuizUseCase,
    required this.getQuizResultsUseCase,
  }) : super(QuizInitialState()) {
    on<GetQuizzesByCourseIdEvent>(_onGetQuizzesByCourseId);
    on<GetQuizDetailEvent>(_onGetQuizDetail);
    on<SubmitQuizEvent>(_onSubmitQuiz);
    on<GetQuizResultsEvent>(_onGetQuizResults);
    on<ResetQuizStateEvent>(_onResetQuizState);
  }

  Future<void> _onGetQuizzesByCourseId(
    GetQuizzesByCourseIdEvent event,
    Emitter<QuizState> emit,
  ) async {
    emit(QuizLoadingState());
    final result = await getQuizzesByCourseIdUseCase(event.courseId);
    result.fold(
      (failure) => emit(QuizErrorState(message: failure.message)),
      (quizList) => emit(QuizListLoadedState(quizzes: quizList.quizzes)),
    );
  }

  Future<void> _onGetQuizDetail(
    GetQuizDetailEvent event,
    Emitter<QuizState> emit,
  ) async {
    emit(QuizLoadingState());
    final result = await getQuizDetailUseCase(event.quizId);
    result.fold(
      (failure) => emit(QuizErrorState(message: failure.message)),
      (quizDetail) => emit(QuizDetailLoadedState(quizDetail: quizDetail)),
    );
  }

  Future<void> _onSubmitQuiz(
    SubmitQuizEvent event,
    Emitter<QuizState> emit,
  ) async {
    emit(QuizLoadingState());
    
    // Convert answers map to API format
    final answersList = event.answers.entries.map((entry) {
      return {
        'question_id': entry.key,
        'answer_id': entry.value,
      };
    }).toList();

    final payload = {
      'user_id': event.userId,
      'answers': answersList,
    };

    final result = await submitQuizUseCase(event.quizId, payload);
    result.fold(
      (failure) => emit(QuizErrorState(message: failure.message)),
      (result) => emit(QuizSubmittedState(result: result)),
    );
  }

  Future<void> _onGetQuizResults(
    GetQuizResultsEvent event,
    Emitter<QuizState> emit,
  ) async {
    emit(QuizLoadingState());
    final result = await getQuizResultsUseCase(event.userId);
    result.fold(
      (failure) => emit(QuizErrorState(message: failure.message)),
      (resultList) => emit(QuizResultsLoadedState(results: resultList.results)),
    );
  }

  Future<void> _onResetQuizState(
    ResetQuizStateEvent event,
    Emitter<QuizState> emit,
  ) async {
    emit(QuizInitialState());
  }
}
