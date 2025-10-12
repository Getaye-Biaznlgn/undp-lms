import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/quiz_model.dart';
import 'package:lms/features/home/data/models/quiz_detail_model.dart';
import 'package:lms/features/home/data/models/quiz_result_model.dart';
import 'package:lms/features/home/data/models/quiz_submission_result_model.dart';

abstract class QuizRepository {
  Future<Either<Failure, QuizListModel>> getQuizzesByCourseId(String courseId);
  Future<Either<Failure, QuizDetailModel>> getQuizDetail(int quizId);
  Future<Either<Failure, QuizSubmissionResultModel>> submitQuiz(int quizId, Map<String, dynamic> payload);
  Future<Either<Failure, QuizResultListModel>> getQuizResults(int userId);
}
