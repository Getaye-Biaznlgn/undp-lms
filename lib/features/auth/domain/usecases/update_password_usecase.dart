import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/domain/repositories/user_profile_repository.dart';

class UpdatePasswordParams extends Equatable {
  final Map<String, dynamic> passwordData;

  const UpdatePasswordParams({required this.passwordData});

  @override
  List<Object> get props => [passwordData];
}

class UpdatePasswordUseCase implements UseCase<bool, UpdatePasswordParams> {
  final UserProfileRepository _repository;

  UpdatePasswordUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(UpdatePasswordParams params) async {
    return await _repository.updatePassword(params.passwordData);
  }
}
