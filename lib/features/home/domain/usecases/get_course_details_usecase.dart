import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/home/data/models/course_detail_model.dart';
import 'package:lms/features/home/domain/repositories/course_detail_repository.dart';

class GetCourseDetailsUseCase implements UseCase<CourseDetailModel, String> {
  final CourseDetailRepository repository;
  
  GetCourseDetailsUseCase({required this.repository});

  @override
  Future<Either<Failure, CourseDetailModel>> call(String slug) async {
    return await repository.getCourseDetails(slug);
  }
}

