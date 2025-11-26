import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/lesson_file_info_model.dart';
import 'package:lms/features/home/data/models/lesson_progress_model.dart';

abstract class LessonRepository {
  Future<Either<Failure, LessonFileInfoResponse>> getFileInfo({
    required String courseId,
    required String lessonId,
  });
  
  Future<Either<Failure, LessonProgressResponse>> getLessonProgress({
    required String courseId,
    required String lessonId,
  });
}


