import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/meeting_model.dart';

abstract class MeetingRepository {
  Future<Either<Failure, MeetingListModel>> getAllMeetings({int? page});
}

