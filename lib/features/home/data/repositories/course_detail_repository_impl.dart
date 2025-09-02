import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/features/home/data/datasources/course_detail_data_source.dart';
import 'package:lms/features/home/data/models/course_detail_model.dart';
import 'package:lms/features/home/domain/repositories/course_detail_repository.dart';
import 'package:logger/logger.dart';

class CourseDetailRepositoryImpl implements CourseDetailRepository {
  final CourseDetailDataSource dataSource;

  CourseDetailRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, CourseDetailModel>> getCourseDetails(String slug) async {
    try {
      final response = await dataSource.getCourseDetails(slug);
      if (response.success && response.data != null) {
        final courseDetail = CourseDetailModel.fromJson(response.data['data']);
        return Right(courseDetail);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }
}

