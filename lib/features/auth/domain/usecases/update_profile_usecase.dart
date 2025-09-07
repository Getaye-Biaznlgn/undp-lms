import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/domain/repositories/user_profile_repository.dart';

class UpdateProfileParams extends Equatable {
  final Map<String, dynamic> profileData;

  const UpdateProfileParams({required this.profileData});

  @override
  List<Object> get props => [profileData];
}

class UpdateProfileUseCase implements UseCase<bool, UpdateProfileParams> {
  final UserProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(UpdateProfileParams params) async {
    return await _repository.updateProfile(params.profileData);
  }
}
