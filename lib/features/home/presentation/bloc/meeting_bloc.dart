import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/home/domain/usecases/get_all_meetings_usecase.dart';
import 'package:lms/features/home/domain/usecases/get_meetings_by_course_id_usecase.dart';
import 'package:lms/features/home/presentation/bloc/meeting_event.dart';
import 'package:lms/features/home/presentation/bloc/meeting_state.dart';

class MeetingBloc extends Bloc<MeetingEvent, MeetingState> {
  final GetAllMeetingsUseCase getAllMeetingsUseCase;
  final GetMeetingsByCourseIdUseCase getMeetingsByCourseIdUseCase;

  MeetingBloc({
    required this.getAllMeetingsUseCase,
    required this.getMeetingsByCourseIdUseCase,
  }) : super(MeetingInitialState()) {
    on<GetAllMeetingsEvent>(_onGetAllMeetings);
    on<GetMeetingsByCourseIdEvent>(_onGetMeetingsByCourseId);
    on<ResetMeetingStateEvent>(_onResetMeetingState);
  }

  Future<void> _onGetAllMeetings(
    GetAllMeetingsEvent event,
    Emitter<MeetingState> emit,
  ) async {
    emit(MeetingLoadingState());
    final result = await getAllMeetingsUseCase(page: event.page);
    result.fold(
      (failure) => emit(MeetingErrorState(message: failure.message)),
      (meetingList) => emit(MeetingsLoadedState(meetingList: meetingList)),
    );
  }

  Future<void> _onGetMeetingsByCourseId(
    GetMeetingsByCourseIdEvent event,
    Emitter<MeetingState> emit,
  ) async {
    emit(MeetingLoadingState());
    final result = await getMeetingsByCourseIdUseCase(event.courseId, page: event.page);
    result.fold(
      (failure) => emit(MeetingErrorState(message: failure.message)),
      (meetingList) => emit(MeetingsLoadedState(meetingList: meetingList)),
    );
  }

  Future<void> _onResetMeetingState(
    ResetMeetingStateEvent event,
    Emitter<MeetingState> emit,
  ) async {
    emit(MeetingInitialState());
  }
}

