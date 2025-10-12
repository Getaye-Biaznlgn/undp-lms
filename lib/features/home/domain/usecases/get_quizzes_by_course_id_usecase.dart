import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/quiz_model.dart';
import 'package:lms/features/home/domain/repositories/quiz_repository.dart';

class GetQuizzesByCourseIdUseCase {
  final QuizRepository repository;

  GetQuizzesByCourseIdUseCase({required this.repository});

  Future<Either<Failure, QuizListModel>> call(String courseId) async {
    return await repository.getQuizzesByCourseId(courseId);
  }
}
