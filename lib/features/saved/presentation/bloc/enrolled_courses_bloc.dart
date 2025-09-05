import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/saved/data/models/enrolled_course_model.dart';
import 'package:lms/features/saved/domain/usecases/get_enrolled_courses_usecase.dart';

part 'enrolled_courses_event.dart';
part 'enrolled_courses_state.dart';

class EnrolledCoursesBloc extends Bloc<EnrolledCoursesEvent, EnrolledCoursesState> {
  final GetEnrolledCoursesUseCase getEnrolledCoursesUseCase;
  List<EnrolledCourseModel> courses = [];

  EnrolledCoursesBloc({
    required this.getEnrolledCoursesUseCase,
  }) : super(EnrolledCoursesInitialState()) {
    on<GetEnrolledCoursesEvent>(_onGetEnrolledCourses);
  }

  Future<void> _onGetEnrolledCourses(
    GetEnrolledCoursesEvent event,
    Emitter<EnrolledCoursesState> emit,
  ) async {
    if(courses.isNotEmpty){
      emit(EnrolledCoursesLoadedState(courses: courses));
      return;
    }
    emit(EnrolledCoursesLoadingState());
    
    final failureOrCourses = await getEnrolledCoursesUseCase(NoParams());
    
    failureOrCourses.fold(
      (failure) => emit(EnrolledCoursesErrorState(message: failure.message)),
      (coursesList) {
        courses = coursesList;
        emit(EnrolledCoursesLoadedState(courses: coursesList));
      },
    );
  }
}
