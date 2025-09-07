import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/domain/repositories/user_profile_repository.dart';

class UpdateBioParams extends Equatable {
  final Map<String, dynamic> bioData;

  const UpdateBioParams({required this.bioData});

  @override
  List<Object> get props => [bioData];
}

class UpdateBioUseCase implements UseCase<bool, UpdateBioParams> {
  final UserProfileRepository _repository;

  UpdateBioUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(UpdateBioParams params) async {
    return await _repository.updateBio(params.bioData);
  }
}
