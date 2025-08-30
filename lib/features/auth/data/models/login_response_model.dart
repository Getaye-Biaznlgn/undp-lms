import 'package:lms/features/auth/domain/entities/login_response.dart';

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({
    required super.message,
    required super.success,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        message: json["message"] ?? "",
        success: json["success"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
      };
}
