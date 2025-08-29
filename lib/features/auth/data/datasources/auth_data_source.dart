import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/services/api_service.dart';
import 'package:lms/core/services/network_response.dart';

abstract class AuthDataSource {
  Future<NetworkResponse> login(Map<String, dynamic> request);
  Future<NetworkResponse> signup(Map<String, dynamic> request);
}

class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl();

  @override
  Future<NetworkResponse> login(Map<String, dynamic> request) async {
    return await ApiService().apiCall(
      endPoint: ApiRoutes.login,
      requestType: RequestType.post,
      body: request,
    );
  }

  @override
  Future<NetworkResponse> signup(Map<String, dynamic> request) async {
    return await ApiService().apiCall(
      endPoint: ApiRoutes.signup,
      requestType: RequestType.post,
      body: request,
    );
  }
}
