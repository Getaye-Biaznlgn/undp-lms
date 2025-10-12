import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/quiz_result_model.dart';
import 'package:lms/features/home/domain/repositories/quiz_repository.dart';

class GetQuizResultsUseCase {
  final QuizRepository repository;

  GetQuizResultsUseCase({required this.repository});

  Future<Either<Failure, QuizResultListModel>> call(int userId) async {
    return await repository.getQuizResults(userId);
  }
}
