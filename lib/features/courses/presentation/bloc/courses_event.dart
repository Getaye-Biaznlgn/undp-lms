part of 'courses_bloc.dart';

abstract class CoursesEvent {}

class GetPopularCoursesEvent extends CoursesEvent {}

class GetCoursesByCategoryEvent extends CoursesEvent {
  final String slug;
  GetCoursesByCategoryEvent({required this.slug});
}

class SearchCoursesEvent extends CoursesEvent {
  final String query;
  SearchCoursesEvent({required this.query});
}
