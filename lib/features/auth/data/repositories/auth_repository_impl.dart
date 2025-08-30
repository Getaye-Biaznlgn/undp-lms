import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/services/localstorage_service.dart';
import 'package:lms/features/auth/data/datasources/auth_data_source.dart';
import 'package:lms/features/auth/data/models/login_response_model.dart';
import 'package:lms/features/auth/domain/entities/login_response.dart';
import 'package:lms/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;
  
  AuthRepositoryImpl({
    required this.authDataSource,
  });

  @override
  Future<Either<Failure, LoginResponse>> login(Map<String, dynamic> request) async {
    try {
      final response = await authDataSource.login(request);
      
      if (response.success) {
        AppPreferences().saveToken(response.data['bearer_token']);
        AppPreferences().saveUserId(response.data['user_id'].toString());
      
        Logger().i("Token = ${response.data['bearer_token']}");
        Logger().i("User ID = ${response.data['user_id']}");
        return Right(LoginResponseModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(message: response.error ?? ''));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> signup(Map<String, dynamic> request) async {
    try {
      final response = await authDataSource.signup(request);
      
      if (response.success) {
        return Right(LoginResponseModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(message: response.error ?? ''));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> forgotPassword(Map<String, dynamic> request) async {
    try {
      final response = await authDataSource.forgotPassword(request);
      
      if (response.success) {
        return Right(LoginResponseModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(message: response.error ?? ''));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> resetPassword(Map<String, dynamic> request) async {
    try {
      final response = await authDataSource.resetPassword(request);
      
      if (response.success) {
        return Right(LoginResponseModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(message: response.error ?? ''));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }
}
