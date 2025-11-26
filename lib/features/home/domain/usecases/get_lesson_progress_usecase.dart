import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/lesson_progress_model.dart';
import 'package:lms/features/home/domain/repositories/lesson_repository.dart';

class GetLessonProgressUseCase {
  final LessonRepository repository;

  GetLessonProgressUseCase({required this.repository});

  Future<Either<Failure, LessonProgressResponse>> call({
    required String courseId,
    required String lessonId,
  }) async {
    return await repository.getLessonProgress(
      courseId: courseId,
      lessonId: lessonId,
    );
  }
}


