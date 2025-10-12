import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/services/api_service.dart';
import 'package:lms/core/services/network_response.dart';

abstract class QuizDataSource {
  Future<NetworkResponse> getQuizzesByCourseId(String courseId);
  Future<NetworkResponse> getQuizDetail(int quizId);
  Future<NetworkResponse> submitQuiz(int quizId, Map<String, dynamic> payload);
  Future<NetworkResponse> getQuizResults(int userId);
}

class QuizDataSourceImpl implements QuizDataSource {
  @override
  Future<NetworkResponse> getQuizzesByCourseId(String courseId) async {
    final endPoint = ApiRoutes.quizeByCourseId.replaceAll('{course_id}', courseId);
    return await ApiService().apiCall(
      endPoint: endPoint,
      requestType: RequestType.get,
    );
  }

  @override
  Future<NetworkResponse> getQuizDetail(int quizId) async {
    final endPoint = ApiRoutes.quizeDetail.replaceAll('{quizeId}', quizId.toString());
    return await ApiService().apiCall(
      endPoint: endPoint,
      requestType: RequestType.get,
    );
  }

  @override
  Future<NetworkResponse> submitQuiz(int quizId, Map<String, dynamic> payload) async {
    final endPoint = ApiRoutes.quizeSubmit.replaceAll('{quizeId}', quizId.toString());
    return await ApiService().apiCall(
      endPoint: endPoint,
      requestType: RequestType.post,
      body: payload,
    );
  }

  @override
  Future<NetworkResponse> getQuizResults(int userId) async {
    final endPoint = ApiRoutes.quizeResult.replaceAll('{userId}', userId.toString());
    return await ApiService().apiCall(
      endPoint: endPoint,
      requestType: RequestType.get,
    );
  }
}
