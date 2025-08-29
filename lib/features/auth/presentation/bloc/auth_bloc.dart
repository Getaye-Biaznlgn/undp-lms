import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/domain/entities/login_response.dart';
import 'package:lms/features/auth/domain/usecases/login_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';
part "auth_event.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  LoginUseCase loginUseCase;
  
  AuthBloc({required this.loginUseCase}) : super(AuthInitialState()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      final failureOrLogin = await loginUseCase(LoginParams(request: event.request));

      failureOrLogin.fold((failure) {
        return emit(AuthErrorState(failure.message));
      }, (loginResponse) {
        return emit(AuthSuccessState(loginResponse));
      });
    });
  }
}
