import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/features/home/data/datasources/quiz_data_source.dart';
import 'package:lms/features/home/data/models/quiz_model.dart';
import 'package:lms/features/home/data/models/quiz_detail_model.dart';
import 'package:lms/features/home/data/models/quiz_result_model.dart';
import 'package:lms/features/home/data/models/quiz_submission_result_model.dart';
import 'package:lms/features/home/domain/repositories/quiz_repository.dart';
import 'package:logger/logger.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizDataSource dataSource;

  QuizRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, QuizListModel>> getQuizzesByCourseId(String courseId) async {
    try {
      final response = await dataSource.getQuizzesByCourseId(courseId);
      if (response.success && response.data != null) {
        final quizList = QuizListModel.fromJson(response.data);
        return Right(quizList);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, QuizDetailModel>> getQuizDetail(int quizId) async {
    try {
      final response = await dataSource.getQuizDetail(quizId);
      if (response.success && response.data != null) {
        final quizDetail = QuizDetailModel.fromJson(response.data);
        return Right(quizDetail);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, QuizSubmissionResultModel>> submitQuiz(int quizId, Map<String, dynamic> payload) async {
    try {
      final response = await dataSource.submitQuiz(quizId, payload);
      if (response.success && response.data != null) {
        final submissionResult = QuizSubmissionResultModel.fromJson(response.data);
        return Right(submissionResult);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, QuizResultListModel>> getQuizResults(int userId) async {
    try {
      final response = await dataSource.getQuizResults(userId);
      if (response.success && response.data != null) {
        final results = QuizResultListModel.fromJson(response.data);
        return Right(results);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }
}
