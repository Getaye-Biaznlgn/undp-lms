import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/course_model.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CourseModel>>> getPopularCourses();
  Future<Either<Failure, List<CourseModel>>> getFreshCourses();
}
