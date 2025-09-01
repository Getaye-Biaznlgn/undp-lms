import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/home/data/models/course_model.dart';
import 'package:lms/features/courses/domain/repositories/courses_repository.dart';

class SearchCoursesUseCase implements UseCase<List<CourseModel>, String> {
  final CoursesRepository repository;
  SearchCoursesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CourseModel>>> call(String query) async {
    return await repository.searchCourses(query);
  }
}
