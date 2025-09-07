import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/services/api_service.dart';
import 'package:lms/core/services/network_response.dart';

abstract class UserProfileDataSource {
  Future<NetworkResponse> getUserProfile();
  Future<NetworkResponse> updateProfile(Map<String, dynamic> profileData);
  Future<NetworkResponse> updateProfilePicture(File imageFile);
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

  @override
  Future<NetworkResponse> updateProfilePicture(File imageFile) async {
    try {
      Logger().i('Starting profile picture upload for file: ${imageFile.path}');
      
      // Create FormData for file upload
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path),
      });
      
      Logger().i('FormData created, making API call to: ${ApiRoutes.updateProfilePicture}');
      
      final response = await ApiService().apiCall(
        endPoint: ApiRoutes.updateProfilePicture,
        body: formData,
        requestType: RequestType.post,
      );
      
      Logger().i('API call completed. Success: ${response.success}, Error: ${response.error}');
      
      return response;
    } catch (e, stackTrace) {
      Logger().e('Error in updateProfilePicture: $e', stackTrace: stackTrace);
      return NetworkResponse.error('Failed to upload profile picture: $e');
    }
  }
}

