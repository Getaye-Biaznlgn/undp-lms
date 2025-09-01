part of 'courses_bloc.dart';

abstract class CoursesState {}

class CoursesInitialState extends CoursesState {}

class CoursesLoadingState extends CoursesState {}

class CoursesLoadedState extends CoursesState {
  final List<CourseModel> courses;
  CoursesLoadedState({required this.courses});
}

class CoursesErrorState extends CoursesState {
  final String message;
  CoursesErrorState({required this.message});
}
