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

class ResetMeetingStateEvent extends MeetingEvent {
  const ResetMeetingStateEvent();
}

