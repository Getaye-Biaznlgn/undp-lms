import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final String message;
  final bool success;

  const LoginResponse({
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [message, success];
}
