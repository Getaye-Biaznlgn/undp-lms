import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/domain/repositories/user_profile_repository.dart';

class UpdateProfilePictureParams extends Equatable {
  final File imageFile;

  const UpdateProfilePictureParams({required this.imageFile});

  @override
  List<Object> get props => [imageFile];
}

class UpdateProfilePictureUseCase implements UseCase<bool, UpdateProfilePictureParams> {
  final UserProfileRepository _repository;

  UpdateProfilePictureUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(UpdateProfilePictureParams params) async {
    return await _repository.updateProfilePicture(params.imageFile);
  }
}
