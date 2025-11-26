import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/services/api_service.dart';
import 'package:lms/core/services/network_response.dart';

abstract class LessonDataSource {
  Future<NetworkResponse> getFileInfo({
    required String courseId,
    required String lessonId,
  });
  
  Future<NetworkResponse> getLessonProgress({
    required String courseId,
    required String lessonId,
  });
}

class LessonDataSourceImpl implements LessonDataSource {
  @override
  Future<NetworkResponse> getFileInfo({
    required String courseId,
    required String lessonId,
  }) async {
    String endPoint = ApiRoutes.getFileInfo
        .replaceAll('{course_id}', courseId)
        .replaceAll('{lesson_id}', lessonId);
    
    return await ApiService().apiCall(
      endPoint: endPoint,
      requestType: RequestType.get,
    );
  }

  @override
  Future<NetworkResponse> getLessonProgress({
    required String courseId,
    required String lessonId,
  }) async {
    String endPoint = ApiRoutes.getLessonProgress
        .replaceAll('{course_id}', courseId)
        .replaceAll('{lesson_id}', lessonId);
    
    return await ApiService().apiCall(
      endPoint: endPoint,
      requestType: RequestType.get,
    );
  }
}

