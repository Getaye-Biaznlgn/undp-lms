import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/quiz_submission_result_model.dart';
import 'package:lms/features/home/domain/repositories/quiz_repository.dart';

class SubmitQuizUseCase {
  final QuizRepository repository;

  SubmitQuizUseCase({required this.repository});

  Future<Either<Failure, QuizSubmissionResultModel>> call(int quizId, Map<String, dynamic> payload) async {
    return await repository.submitQuiz(quizId, payload);
  }
}
