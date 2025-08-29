part of "auth_bloc.dart";

@immutable
abstract class AuthEvent extends Equatable {}

class LoginEvent extends AuthEvent {
  final Map<String, dynamic> request;
  LoginEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class SignupEvent extends AuthEvent {
  final Map<String, dynamic> request;
  SignupEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class ForgotPasswordEvent extends AuthEvent {
  final Map<String, dynamic> request;
  ForgotPasswordEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class ResetPasswordEvent extends AuthEvent {
  final Map<String, dynamic> request;
  ResetPasswordEvent(this.request);

  @override
  List<Object?> get props => [request];
}
