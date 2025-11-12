import 'package:dartz/dartz.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/home/data/models/meeting_model.dart';
import 'package:lms/features/home/domain/repositories/meeting_repository.dart';

class GetAllMeetingsUseCase {
  final MeetingRepository repository;

  GetAllMeetingsUseCase({required this.repository});

  Future<Either<Failure, MeetingListModel>> call({int? page}) async {
    return await repository.getAllMeetings(page: page);
  }
}

