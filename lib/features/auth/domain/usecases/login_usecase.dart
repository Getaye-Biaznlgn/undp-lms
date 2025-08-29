import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/domain/entities/login_response.dart';
import 'package:lms/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class LoginUseCase implements UseCase<LoginResponse, LoginParams> {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, LoginResponse>> call(LoginParams params) async {
    return await repository.login(params.request);
  }
}

class LoginParams extends Equatable {
  final Map<String, dynamic> request;
  const LoginParams({required this.request});

  @override
  List<Object> get props => [request];
}
