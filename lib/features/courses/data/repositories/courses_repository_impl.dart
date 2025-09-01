import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/features/courses/data/datasources/courses_data_source.dart';
import 'package:lms/features/courses/domain/repositories/courses_repository.dart';
import 'package:lms/features/home/data/models/category_model.dart';
import 'package:lms/features/home/data/models/course_model.dart';
import 'package:logger/logger.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesDataSource dataSource;
  CoursesRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<CategoryModel>>> getCourseMainCategories() async {
    try {
      final response = await dataSource.getCourseMainCategories();
      if (response.success && response.data != null) {
        final List<dynamic> categoriesData = response.data['data'] ?? [];
        final List<CategoryModel> categories = categoriesData
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        return Right(categories);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }

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
  Future<Either<Failure, List<CourseModel>>> getCoursesByCategory(String slug) async {
    try {
      final response = await dataSource.getCoursesByCategory(slug);
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
  Future<Either<Failure, List<CourseModel>>> searchCourses(String query) async {
    try {
      final response = await dataSource.searchCourses(query);
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
}
