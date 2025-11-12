import 'package:equatable/equatable.dart';
import 'package:lms/features/home/data/models/meeting_model.dart';

abstract class MeetingState extends Equatable {
  const MeetingState();

  @override
  List<Object?> get props => [];
}

class MeetingInitialState extends MeetingState {}

class MeetingLoadingState extends MeetingState {}

class MeetingsLoadedState extends MeetingState {
  final MeetingListModel meetingList;

  const MeetingsLoadedState({required this.meetingList});

  @override
  List<Object?> get props => [meetingList];
}

class MeetingErrorState extends MeetingState {
  final String message;

  const MeetingErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

