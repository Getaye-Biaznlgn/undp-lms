import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/datasources/home_data_source.dart';
import 'package:lms/features/home/domain/repositories/home_repository.dart';
import 'package:lms/features/home/data/models/course_model.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<CourseModel>>> getPopularCourses() async {
    try {
      final response = await dataSource.getPopularCourses();
      if (response.success && response.data != null) {
        final List<dynamic> coursesData = response.data['data'] ?? [];
        final List<CourseModel> courses = coursesData
            .map((json) => CourseModel.fromJson(json))
            .toList();
        
        return Right(courses);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<CourseModel>>> getFreshCourses() async {
    try {
      final response = await dataSource.getFreshCourses();
      if (response.success && response.data != null) {
        // Parse the courses from the response
        final List<dynamic> coursesData = response.data['data'] ?? [];
        final List<CourseModel> courses = coursesData
            .map((json) => CourseModel.fromJson(json))
            .toList();
        return Right(courses);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }
}
