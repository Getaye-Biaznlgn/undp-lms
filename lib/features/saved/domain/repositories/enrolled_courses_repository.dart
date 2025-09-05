import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/saved/data/models/enrolled_course_model.dart';

abstract class EnrolledCoursesRepository {
  Future<Either<Failure, List<EnrolledCourseModel>>> getEnrolledCourses();
}
