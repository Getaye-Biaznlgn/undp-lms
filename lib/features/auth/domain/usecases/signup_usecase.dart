import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/domain/entities/login_response.dart';
import 'package:lms/features/auth/domain/repositories/auth_repository.dart';

class SignupParams extends Equatable {
  final Map<String, dynamic> request;
  const SignupParams({required this.request});

  @override
  List<Object?> get props => [request];
}

class SignupUseCase implements UseCase<LoginResponse, SignupParams> {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<Either<Failure, LoginResponse>> call(SignupParams params) async {
    return await repository.signup(params.request);
  }
}
