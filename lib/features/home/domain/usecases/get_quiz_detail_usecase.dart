import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/quiz_detail_model.dart';
import 'package:lms/features/home/domain/repositories/quiz_repository.dart';

class GetQuizDetailUseCase {
  final QuizRepository repository;

  GetQuizDetailUseCase({required this.repository});

  Future<Either<Failure, QuizDetailModel>> call(int quizId) async {
    return await repository.getQuizDetail(quizId);
  }
}
