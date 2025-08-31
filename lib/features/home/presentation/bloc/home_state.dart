part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomePopularCoursesLoadedState extends HomeState {
  final List<CourseModel> courses;
  
  HomePopularCoursesLoadedState({required this.courses});
}

class HomeFreshCoursesLoadedState extends HomeState {
  final List<CourseModel> courses;
  
  HomeFreshCoursesLoadedState({required this.courses});
}

class HomeErrorState extends HomeState {
  final String message;
  
  HomeErrorState({required this.message});
}
