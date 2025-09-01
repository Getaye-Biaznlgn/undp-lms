import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/home/data/models/course_model.dart';
import 'package:lms/features/home/domain/usecases/get_popular_courses_usecase.dart';
import 'package:lms/features/courses/domain/usecases/get_courses_by_category_usecase.dart';
import 'package:lms/features/courses/domain/usecases/search_courses_usecase.dart';

part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final GetPopularCoursesUseCase getPopularCoursesUseCase;
  final GetCoursesByCategoryUseCase getCoursesByCategoryUseCase;
  final SearchCoursesUseCase searchCoursesUseCase;
  List<CourseModel> courses = [];

  CoursesBloc({
    required this.getPopularCoursesUseCase,
    required this.getCoursesByCategoryUseCase,
    required this.searchCoursesUseCase,
  }) : super(CoursesInitialState()) {
    on<GetPopularCoursesEvent>(_onGetPopularCourses);
    on<GetCoursesByCategoryEvent>(_onGetCoursesByCategory);
    on<SearchCoursesEvent>(_onSearchCourses);
  }

  Future<void> _onGetPopularCourses(GetPopularCoursesEvent event, Emitter<CoursesState> emit) async {
    emit(CoursesLoadingState());
    final failureOrCourses = await getPopularCoursesUseCase(NoParams());
    failureOrCourses.fold(
      (failure) => emit(CoursesErrorState(message: failure.message)),
      (coursesList) {
        courses = coursesList;
        emit(CoursesLoadedState(courses: coursesList));
      },
    );
  }

  Future<void> _onGetCoursesByCategory(GetCoursesByCategoryEvent event, Emitter<CoursesState> emit) async {
    emit(CoursesLoadingState());
    final failureOrCourses = await getCoursesByCategoryUseCase(event.slug);
    failureOrCourses.fold(
      (failure) => emit(CoursesErrorState(message: failure.message)),
      (coursesList) {
        courses = coursesList;
        emit(CoursesLoadedState(courses: coursesList));
      },
    );
  }

  Future<void> _onSearchCourses(SearchCoursesEvent event, Emitter<CoursesState> emit) async {
    emit(CoursesLoadingState());
    final failureOrCourses = await searchCoursesUseCase(event.query);
    failureOrCourses.fold(
      (failure) => emit(CoursesErrorState(message: failure.message)),
      (coursesList) {
        courses = coursesList;
        emit(CoursesLoadedState(courses: coursesList));
      },
    );
  }
}
