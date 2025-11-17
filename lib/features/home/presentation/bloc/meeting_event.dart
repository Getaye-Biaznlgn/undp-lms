import 'package:equatable/equatable.dart';

abstract class MeetingEvent extends Equatable {
  const MeetingEvent();

  @override
  List<Object?> get props => [];
}

class GetAllMeetingsEvent extends MeetingEvent {
  final int? page;

  const GetAllMeetingsEvent({this.page});

  @override
  List<Object?> get props => [page];
}

class GetMeetingsByCourseIdEvent extends MeetingEvent {
  final String courseId;
  final int? page;

  const GetMeetingsByCourseIdEvent({required this.courseId, this.page});

  @override
  List<Object?> get props => [courseId, page];
}

class ResetMeetingStateEvent extends MeetingEvent {
  const ResetMeetingStateEvent();
}

