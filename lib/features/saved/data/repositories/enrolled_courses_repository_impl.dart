import 'package:dartz/dartz.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/saved/data/datasources/enrolled_courses_data_source.dart';
import 'package:lms/features/saved/data/models/enrolled_course_model.dart';
import 'package:lms/features/saved/domain/repositories/enrolled_courses_repository.dart';
import 'package:logger/logger.dart';

class EnrolledCoursesRepositoryImpl implements EnrolledCoursesRepository {
  final EnrolledCoursesDataSource dataSource;

  EnrolledCoursesRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<EnrolledCourseModel>>> getEnrolledCourses() async {
    try {
      final response = await dataSource.getEnrolledCourses();
      if (response.success && response.data != null) {
        final List<dynamic> coursesData = response.data["data"] ?? [];
        final List<EnrolledCourseModel> courses = coursesData
            .map((json) => EnrolledCourseModel.fromJson(json))
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
