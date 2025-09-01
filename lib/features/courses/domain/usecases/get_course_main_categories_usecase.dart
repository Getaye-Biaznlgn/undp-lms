import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/home/data/models/category_model.dart';
import 'package:lms/features/courses/domain/repositories/courses_repository.dart';

class GetCourseMainCategoriesUseCase implements UseCase<List<CategoryModel>, NoParams> {
  final CoursesRepository repository;
  GetCourseMainCategoriesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CategoryModel>>> call(NoParams params) async {
    return await repository.getCourseMainCategories();
  }
}
