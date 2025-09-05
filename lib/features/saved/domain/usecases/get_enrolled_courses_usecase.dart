import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/saved/data/models/enrolled_course_model.dart';
import 'package:lms/features/saved/domain/repositories/enrolled_courses_repository.dart';

class GetEnrolledCoursesUseCase implements UseCase<List<EnrolledCourseModel>, NoParams> {
  final EnrolledCoursesRepository repository;

  GetEnrolledCoursesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<EnrolledCourseModel>>> call(NoParams params) async {
    return await repository.getEnrolledCourses();
  }
}
