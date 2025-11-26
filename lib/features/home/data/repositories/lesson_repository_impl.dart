import 'package:dartz/dartz.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/error/failures.dart';
import 'package:logger/logger.dart';
import 'package:lms/features/home/data/datasources/lesson_data_source.dart';
import 'package:lms/features/home/data/models/lesson_file_info_model.dart';
import 'package:lms/features/home/data/models/lesson_progress_model.dart';
import 'package:lms/features/home/domain/repositories/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonDataSource dataSource;

  LessonRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, LessonFileInfoResponse>> getFileInfo({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      final response = await dataSource.getFileInfo(
        courseId: courseId,
        lessonId: lessonId,
      );
      if (response.success && response.data != null) {
        final fileInfo = LessonFileInfoResponse.fromJson(response.data);
        return Right(fileInfo);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, LessonProgressResponse>> getLessonProgress({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      final response = await dataSource.getLessonProgress(
        courseId: courseId,
        lessonId: lessonId,
      );
      if (response.success && response.data != null) {
        final progress = LessonProgressResponse.fromJson(response.data);
        return Right(progress);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }
}

