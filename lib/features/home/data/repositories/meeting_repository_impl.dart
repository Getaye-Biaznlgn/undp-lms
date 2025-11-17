import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/features/home/data/datasources/meeting_data_source.dart';
import 'package:lms/features/home/data/models/meeting_model.dart';
import 'package:lms/features/home/domain/repositories/meeting_repository.dart';
import 'package:logger/logger.dart';

class MeetingRepositoryImpl implements MeetingRepository {
  final MeetingDataSource dataSource;

  MeetingRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, MeetingListModel>> getAllMeetings({int? page}) async {
    try {
      final response = await dataSource.getAllMeetings(page: page);
      if (response.success && response.data != null) {
        final meetingList = MeetingListModel.fromJson(response.data);
        return Right(meetingList);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, MeetingListModel>> getMeetingsByCourseId(String courseId, {int? page}) async {
    try {
      final response = await dataSource.getMeetingsByCourseId(courseId, page: page);
      if (response.success && response.data != null) {
        final meetingList = MeetingListModel.fromJson(response.data);
        return Right(meetingList);
      } else {
        return Left(ServerFailure(message: response.error ?? errorMessage));
      }
    } catch (exception, stackTrace) {
      Logger().e(exception, stackTrace: stackTrace);
      return const Left(ServerFailure(message: errorMessage));
    }
  }
}

