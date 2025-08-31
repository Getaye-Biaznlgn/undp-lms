import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/services/api_service.dart';
import 'package:lms/core/services/network_response.dart';

abstract class HomeDataSource {
  Future<NetworkResponse> getPopularCourses();
  Future<NetworkResponse> getFreshCourses();
}

class HomeDataSourceImpl implements HomeDataSource {
  @override
  Future<NetworkResponse> getPopularCourses() async {
    return await ApiService().apiCall(
      endPoint: ApiRoutes.popularCourses,
      requestType: RequestType.get,
    );
  }

  @override
  Future<NetworkResponse> getFreshCourses() async {
    return await ApiService().apiCall(
      endPoint: ApiRoutes.freshCourses,
      requestType: RequestType.get,
    );
  }
}
