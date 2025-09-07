import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/data/models/user_profile_model.dart';
import 'package:lms/features/auth/domain/repositories/user_profile_repository.dart';

class GetUserProfileUseCase implements UseCase<UserProfileModel, NoParams> {
  final UserProfileRepository repository;

  GetUserProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, UserProfileModel>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}

