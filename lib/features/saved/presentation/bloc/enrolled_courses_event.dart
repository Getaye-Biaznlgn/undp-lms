part of 'enrolled_courses_bloc.dart';
abstract class EnrolledCoursesEvent extends Equatable {
  const EnrolledCoursesEvent();

  @override
  List<Object> get props => [];
}

class GetEnrolledCoursesEvent extends EnrolledCoursesEvent {
  const GetEnrolledCoursesEvent();
}
