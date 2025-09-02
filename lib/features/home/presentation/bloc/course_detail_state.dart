part of 'course_detail_bloc.dart';

abstract class CourseDetailState extends Equatable {
  const CourseDetailState();

  @override
  List<Object> get props => [];
}

class CourseDetailInitialState extends CourseDetailState {}

class CourseDetailLoadingState extends CourseDetailState {}

class CourseDetailLoadedState extends CourseDetailState {
  final CourseDetailModel courseDetail;

  const CourseDetailLoadedState({required this.courseDetail});

  @override
  List<Object> get props => [courseDetail];
}

class CourseDetailErrorState extends CourseDetailState {
  final String message;

  const CourseDetailErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

