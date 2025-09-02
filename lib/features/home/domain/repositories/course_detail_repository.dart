import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/course_detail_model.dart';

abstract class CourseDetailRepository {
  Future<Either<Failure, CourseDetailModel>> getCourseDetails(String slug);
}

