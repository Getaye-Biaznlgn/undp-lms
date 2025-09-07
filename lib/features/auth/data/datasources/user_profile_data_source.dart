import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/services/api_service.dart';
import 'package:lms/core/services/network_response.dart';

abstract class UserProfileDataSource {
  Future<NetworkResponse> getUserProfile();
  Future<NetworkResponse> updateProfile(Map<String, dynamic> profileData);
}

class UserProfileDataSourceImpl implements UserProfileDataSource {
  @override
  Future<NetworkResponse> getUserProfile() async {
    return await ApiService().apiCall(
      endPoint: ApiRoutes.profile,
      requestType: RequestType.get,
    );
  }

  @override
  Future<NetworkResponse> updateProfile(Map<String, dynamic> profileData) async {
    return await ApiService().apiCall(
      endPoint: ApiRoutes.updateProfile,
      body: profileData,
      requestType: RequestType.put,
    );
  }
}

