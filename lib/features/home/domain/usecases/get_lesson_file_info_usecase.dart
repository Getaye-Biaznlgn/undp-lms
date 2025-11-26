import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/lesson_file_info_model.dart';
import 'package:lms/features/home/domain/repositories/lesson_repository.dart';

class GetLessonFileInfoUseCase {
  final LessonRepository repository;

  GetLessonFileInfoUseCase({required this.repository});

  Future<Either<Failure, LessonFileInfoResponse>> call({
    required String courseId,
    required String lessonId,
  }) async {
    return await repository.getFileInfo(
      courseId: courseId,
      lessonId: lessonId,
    );
  }
}


