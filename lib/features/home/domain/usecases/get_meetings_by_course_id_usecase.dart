import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/meeting_model.dart';
import 'package:lms/features/home/domain/repositories/meeting_repository.dart';

class GetMeetingsByCourseIdUseCase {
  final MeetingRepository repository;

  GetMeetingsByCourseIdUseCase({required this.repository});

  Future<Either<Failure, MeetingListModel>> call(String courseId, {int? page}) async {
    return await repository.getMeetingsByCourseId(courseId, page: page);
  }
}



