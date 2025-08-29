import 'package:lms/features/auth/domain/entities/login_response.dart';

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({
    required String token,
    required String message,
    required bool success,
  }) : super(token: token, message: message, success: success);

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        token: json["token"] ?? "",
        message: json["message"] ?? "",
        success: json["success"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "message": message,
        "success": success,
      };
}
