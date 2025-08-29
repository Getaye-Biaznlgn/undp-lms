import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final String token;
  final String message;
  final bool success;

  const LoginResponse({
    required this.token,
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [token, message, success];
}
