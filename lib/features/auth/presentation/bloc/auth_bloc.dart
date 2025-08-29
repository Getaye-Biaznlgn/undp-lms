import 'package:lms/features/auth/domain/entities/login_response.dart';
import 'package:lms/features/auth/domain/usecases/login_usecase.dart';
import 'package:lms/features/auth/domain/usecases/signup_usecase.dart';
import 'package:lms/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:lms/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';
part "auth_event.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  LoginUseCase loginUseCase;
  SignupUseCase signupUseCase;
  ForgotPasswordUseCase forgotPasswordUseCase;
  ResetPasswordUseCase resetPasswordUseCase;
  
  AuthBloc({required this.loginUseCase, required this.signupUseCase, required this.forgotPasswordUseCase, required this.resetPasswordUseCase}) : super(AuthInitialState()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      final failureOrLogin = await loginUseCase(LoginParams(request: event.request));

      failureOrLogin.fold((failure) {
        return emit(AuthErrorState(failure.message));
      }, (loginResponse) {
        return emit(AuthSuccessState(loginResponse));
      });
    });

    on<SignupEvent>((event, emit) async {
      emit(AuthLoadingState());
      final failureOrSignup = await signupUseCase(SignupParams(request: event.request));

      failureOrSignup.fold((failure) {
        return emit(AuthErrorState(failure.message));
      }, (signupResponse) {
        return emit(AuthSuccessState(signupResponse));
      });
    });

    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoadingState());
      final failureOrForgotPassword = await forgotPasswordUseCase(ForgotPasswordParams(request: event.request));

      failureOrForgotPassword.fold((failure) {
        return emit(AuthErrorState(failure.message));
      }, (forgotPasswordResponse) {
        return emit(AuthSuccessState(forgotPasswordResponse));
      });
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoadingState());
      final failureOrResetPassword = await resetPasswordUseCase(ResetPasswordParams(request: event.request));

      failureOrResetPassword.fold((failure) {
        return emit(AuthErrorState(failure.message));
      }, (resetPasswordResponse) {
        return emit(AuthSuccessState(resetPasswordResponse));
      });
    });
  }
}
