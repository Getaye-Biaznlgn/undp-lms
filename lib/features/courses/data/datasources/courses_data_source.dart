import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/services/api_service.dart';
import 'package:lms/core/services/network_response.dart';

abstract class CoursesDataSource {
  Future<NetworkResponse> getCourseMainCategories();
  Future<NetworkResponse> getPopularCourses();
  Future<NetworkResponse> getCoursesByCategory(String slug);
  Future<NetworkResponse> searchCourses(String query);
}

class CoursesDataSourceImpl implements CoursesDataSource {

  @override
  Future<NetworkResponse> getCourseMainCategories() async {
    return await  ApiService().apiCall(
      endPoint: ApiRoutes.courseMainCategories, 
      requestType: RequestType.get
    );
  }

  @override
  Future<NetworkResponse> getPopularCourses() async {
    return await ApiService().apiCall(
      endPoint: ApiRoutes.popularCourses,
      requestType: RequestType.get
    );
  }

  @override
  Future<NetworkResponse> getCoursesByCategory(String slug) async {
    final endPoint = ApiRoutes.coursesByCategory.replaceAll('{slug}', slug);
    return await ApiService().apiCall(
      endPoint: endPoint,
      requestType: RequestType.get
    );
  }

  @override
  Future<NetworkResponse> searchCourses(String query) async {
    final endPoint = ApiRoutes.searchCourses.replaceAll('{search}', query);
    return await ApiService().apiCall(
      endPoint: endPoint,
      requestType: RequestType.get
    );
  }
}

