import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/auth/data/models/user_profile_model.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfileModel>> getUserProfile();
  Future<Either<Failure, bool>> updateProfile(Map<String, dynamic> profileData);
}

