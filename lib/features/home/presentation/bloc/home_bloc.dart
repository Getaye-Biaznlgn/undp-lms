import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/home/data/models/course_model.dart';
import 'package:lms/features/home/domain/usecases/get_popular_courses_usecase.dart';
import 'package:lms/features/home/domain/usecases/get_fresh_courses_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPopularCoursesUseCase getPopularCoursesUseCase;
  final GetFreshCoursesUseCase getFreshCoursesUseCase;
 List<CourseModel> popularCourses = [];
 List<CourseModel> freshCourses = [];

  HomeBloc({
    required this.getPopularCoursesUseCase,
    required this.getFreshCoursesUseCase,
  })  : 
        super(HomeInitialState()) {
    
    on<GetPopularCoursesEvent>(_onGetPopularCourses);
    on<GetFreshCoursesEvent>(_onGetFreshCourses);
  }

  Future<void> _onGetPopularCourses(
    GetPopularCoursesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    
    final failureOrCourses = await getPopularCoursesUseCase(NoParams());
    
    failureOrCourses.fold(
      (failure) => emit(HomeErrorState(message: failure.message)),
      (courses) {
        popularCourses = courses;
        emit(HomePopularCoursesLoadedState(courses: courses));
      },
    );
  }

  Future<void> _onGetFreshCourses(
    GetFreshCoursesEvent event,
    Emitter<HomeState> emit,
  ) async {
    final failureOrCourses = await getFreshCoursesUseCase(NoParams());
    
    failureOrCourses.fold(
      (failure) => emit(HomeErrorState(message: failure.message)),
      (courses) {
        freshCourses = courses;
        emit(HomeFreshCoursesLoadedState(courses: courses));
      },
    );
  }
}
