part of 'course_detail_bloc.dart';

abstract class CourseDetailEvent extends Equatable {
  const CourseDetailEvent();

  @override
  List<Object> get props => [];
}

class GetCourseDetailsEvent extends CourseDetailEvent {
  final String slug;

  const GetCourseDetailsEvent({required this.slug});

  @override
  List<Object> get props => [slug];
}

