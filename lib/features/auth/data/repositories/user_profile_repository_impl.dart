import 'package:dartz/dartz.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/auth/data/datasources/user_profile_data_source.dart';
import 'package:lms/features/auth/data/models/user_profile_model.dart';
import 'package:lms/features/auth/domain/repositories/user_profile_repository.dart';
import 'package:logger/logger.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileDataSource dataSource;

  UserProfileRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserProfileModel>> getUserProfile() async {
    try {
      final response = await dataSource.getUserProfile();
      if (response.success && response.data != null) {
        final userProfileData = response.data['data'] ?? {};
        final userProfile = UserProfileModel.fromJson(userProfileData);
        
        return Right(userProfile);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await dataSource.updateProfile(profileData);
      if (response.success && response.data != null) {
        // Check if the response indicates success
        final status = response.data['status'];
        if (status == 'success') {
          return const Right(true);
        } else {
          return Left(ServerFailure(message: response.data['message'] ?? errorMessage));
        }
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }
}

