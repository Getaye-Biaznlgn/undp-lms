import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/domain/entities/login_response.dart';
import 'package:lms/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordParams extends Equatable {
  final Map<String, dynamic> request;
  const ResetPasswordParams({required this.request});

  @override
  List<Object?> get props => [request];
}

class ResetPasswordUseCase implements UseCase<LoginResponse, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, LoginResponse>> call(ResetPasswordParams params) async {
    return await repository.resetPassword(params.request);
  }
}
