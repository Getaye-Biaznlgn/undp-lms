
part of 'enrolled_courses_bloc.dart';

abstract class EnrolledCoursesState extends Equatable {
  const EnrolledCoursesState();

  @override
  List<Object> get props => [];
}

class EnrolledCoursesInitialState extends EnrolledCoursesState {}

class EnrolledCoursesLoadingState extends EnrolledCoursesState {}

class EnrolledCoursesLoadedState extends EnrolledCoursesState {
  final List<EnrolledCourseModel> courses;

  const EnrolledCoursesLoadedState({required this.courses});

  @override
  List<Object> get props => [courses];
}

class EnrolledCoursesErrorState extends EnrolledCoursesState {
  final String message;

  const EnrolledCoursesErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
