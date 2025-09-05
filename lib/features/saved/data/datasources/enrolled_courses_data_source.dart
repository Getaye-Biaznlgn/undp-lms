import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/services/api_service.dart';
import 'package:lms/core/services/network_response.dart';

abstract class EnrolledCoursesDataSource {
  Future<NetworkResponse> getEnrolledCourses();
}

class EnrolledCoursesDataSourceImpl implements EnrolledCoursesDataSource {
  @override
  Future<NetworkResponse> getEnrolledCourses() async {
    return await ApiService().apiCall(
      endPoint: ApiRoutes.enrolledCourses,
      requestType: RequestType.get,
    );
  }
}
