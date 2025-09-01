import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/category_model.dart';
import 'package:lms/features/home/data/models/course_model.dart';

abstract class CoursesRepository {
  Future<Either<Failure, List<CategoryModel>>> getCourseMainCategories();
  Future<Either<Failure, List<CourseModel>>> getPopularCourses();
  Future<Either<Failure, List<CourseModel>>> getCoursesByCategory(String slug);
  Future<Either<Failure, List<CourseModel>>> searchCourses(String query);
}
