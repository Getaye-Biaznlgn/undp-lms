import 'package:lms/core/error/failures.dart';
import 'package:lms/features/auth/domain/entities/login_response.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(Map<String, dynamic> request);
}
