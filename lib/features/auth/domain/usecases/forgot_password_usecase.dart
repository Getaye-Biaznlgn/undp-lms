import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/domain/entities/login_response.dart';
import 'package:lms/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordParams extends Equatable {
  final Map<String, dynamic> request;
  const ForgotPasswordParams({required this.request});

  @override
  List<Object?> get props => [request];
}

class ForgotPasswordUseCase implements UseCase<LoginResponse, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, LoginResponse>> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(params.request);
  }
}
