import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/home/data/models/course_detail_model.dart';
import 'package:lms/features/home/domain/usecases/get_course_details_usecase.dart';

part 'course_detail_event.dart';
part 'course_detail_state.dart';

class CourseDetailBloc extends Bloc<CourseDetailEvent, CourseDetailState> {
  final GetCourseDetailsUseCase getCourseDetailsUseCase;

  CourseDetailBloc({
    required this.getCourseDetailsUseCase,
  }) : super(CourseDetailInitialState()) {
    on<GetCourseDetailsEvent>(_onGetCourseDetails);
  }

  Future<void> _onGetCourseDetails(GetCourseDetailsEvent event, Emitter<CourseDetailState> emit) async {
    emit(CourseDetailLoadingState());
    final failureOrCourseDetail = await getCourseDetailsUseCase(event.slug);
    failureOrCourseDetail.fold(
      (failure) => emit(CourseDetailErrorState(message: failure.message)),
      (courseDetail) => emit(CourseDetailLoadedState(courseDetail: courseDetail)),
    );
  }
}
