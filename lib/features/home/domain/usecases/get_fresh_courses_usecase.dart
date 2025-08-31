import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/home/data/models/course_model.dart';
import 'package:lms/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';

class GetFreshCoursesUseCase implements UseCase<List<CourseModel>, NoParams> {
  final HomeRepository repository;

  GetFreshCoursesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CourseModel>>> call(NoParams params) async {
    return await repository.getFreshCourses();
  }
}
