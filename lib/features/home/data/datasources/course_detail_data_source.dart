import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/services/api_service.dart';
import 'package:lms/core/services/network_response.dart';

abstract class CourseDetailDataSource {
  Future<NetworkResponse> getCourseDetails(String slug);
}

class CourseDetailDataSourceImpl implements CourseDetailDataSource {
  @override
  Future<NetworkResponse> getCourseDetails(String slug) async {
    final endPoint = ApiRoutes.courseDetails.replaceAll('{slug}', slug);
    return await ApiService().apiCall(
      endPoint: endPoint,
      requestType: RequestType.get,
    );
  }
}
