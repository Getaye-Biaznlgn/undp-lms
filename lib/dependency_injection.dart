import 'package:lms/core/network/network_info.dart';
import 'package:lms/core/services/api_service.dart';
import 'package:lms/features/todo/data/datasources/todo_data_source.dart';
import 'package:lms/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:lms/features/todo/domain/repositories/todo_repository.dart';
import 'package:lms/features/todo/domain/usecases/get_all_todos.dart';
import 'package:lms/features/todo/domain/usecases/get_todo.dart';
import 'package:lms/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:lms/features/main/presentation/bloc/main_bloc.dart';
import 'package:lms/features/auth/data/datasources/auth_data_source.dart';
import 'package:lms/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lms/features/auth/domain/repositories/auth_repository.dart';
import 'package:lms/features/auth/domain/usecases/login_usecase.dart';
import 'package:lms/features/auth/domain/usecases/signup_usecase.dart';
import 'package:lms/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:lms/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:lms/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lms/features/home/data/datasources/home_data_source.dart';
import 'package:lms/features/home/data/repositories/home_repository.dart';
import 'package:lms/features/home/domain/repositories/home_repository.dart';
import 'package:lms/features/home/domain/usecases/get_popular_courses_usecase.dart';
import 'package:lms/features/home/domain/usecases/get_fresh_courses_usecase.dart';

import 'package:lms/features/home/presentation/bloc/home_bloc.dart';
import 'package:lms/features/courses/data/datasources/courses_data_source.dart';
import 'package:lms/features/courses/data/repositories/courses_repository_impl.dart';
import 'package:lms/features/courses/domain/repositories/courses_repository.dart';
import 'package:lms/features/courses/domain/usecases/get_course_main_categories_usecase.dart';
import 'package:lms/features/courses/domain/usecases/get_courses_by_category_usecase.dart';
import 'package:lms/features/courses/domain/usecases/search_courses_usecase.dart';
import 'package:lms/features/courses/presentation/bloc/category_bloc.dart';
import 'package:lms/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:lms/features/home/data/datasources/course_detail_data_source.dart';
import 'package:lms/features/home/data/datasources/quiz_data_source.dart';
import 'package:lms/features/home/data/repositories/course_detail_repository_impl.dart';
import 'package:lms/features/home/data/repositories/quiz_repository_impl.dart';
import 'package:lms/features/home/domain/repositories/course_detail_repository.dart';
import 'package:lms/features/home/domain/repositories/quiz_repository.dart';
import 'package:lms/features/home/domain/usecases/get_course_details_usecase.dart';
import 'package:lms/features/home/domain/usecases/get_quizzes_by_course_id_usecase.dart';
import 'package:lms/features/home/domain/usecases/get_quiz_detail_usecase.dart';
import 'package:lms/features/home/domain/usecases/submit_quiz_usecase.dart';
import 'package:lms/features/home/domain/usecases/get_quiz_results_usecase.dart';
import 'package:lms/features/home/presentation/bloc/course_detail_bloc.dart';
import 'package:lms/features/home/presentation/bloc/quiz_bloc.dart';
import 'package:lms/features/saved/data/datasources/enrolled_courses_data_source.dart';
import 'package:lms/features/saved/data/repositories/enrolled_courses_repository_impl.dart';
import 'package:lms/features/saved/domain/repositories/enrolled_courses_repository.dart';
import 'package:lms/features/saved/domain/usecases/get_enrolled_courses_usecase.dart';
import 'package:lms/features/saved/presentation/bloc/enrolled_courses_bloc.dart';
import 'package:lms/features/auth/data/datasources/user_profile_data_source.dart';
import 'package:lms/features/auth/data/repositories/user_profile_repository_impl.dart';
import 'package:lms/features/auth/domain/repositories/user_profile_repository.dart';
import 'package:lms/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:lms/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:lms/features/auth/domain/usecases/update_profile_picture_usecase.dart';
import 'package:lms/features/auth/domain/usecases/update_bio_usecase.dart';
import 'package:lms/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:lms/features/auth/presentation/bloc/user_profile_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerLazySingleton(
    () => TodoBloc(
       getTodo: sl(),
       getAllTodos: sl()
    ),
  );
  sl.registerLazySingleton(() => MainBloc());
  sl.registerLazySingleton(
    () => AuthBloc(
      loginUseCase: sl(),
      signupUseCase: sl(),
      forgotPasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );
            sl.registerLazySingleton(
            () => HomeBloc(
              getPopularCoursesUseCase: sl(),
              getFreshCoursesUseCase: sl(),
            ),
          );
          sl.registerLazySingleton(
            () => CategoryBloc(
              getCourseMainCategoriesUseCase: sl(),
            ),
          );
          sl.registerLazySingleton(
            () => CoursesBloc(
              getPopularCoursesUseCase: sl(),
              getCoursesByCategoryUseCase: sl(),
              searchCoursesUseCase: sl(),
            ),
          );
          sl.registerLazySingleton(
            () => CourseDetailBloc(
              getCourseDetailsUseCase: sl(),
            ),
          );
          sl.registerLazySingleton(
            () => QuizBloc(
              getQuizzesByCourseIdUseCase: sl(),
              getQuizDetailUseCase: sl(),
              submitQuizUseCase: sl(),
              getQuizResultsUseCase: sl(),
            ),
          );
          sl.registerLazySingleton(
            () => EnrolledCoursesBloc(
              getEnrolledCoursesUseCase: sl(),
            ),
          );
          sl.registerLazySingleton(
            () => UserProfileBloc(
              getUserProfileUseCase: sl(),
              updateProfileUseCase: sl(),
              updateProfilePictureUseCase: sl(),
              updateBioUseCase: sl(),
              updatePasswordUseCase: sl(),
            ),
          );

  // Use cases
  sl.registerLazySingleton(() => GetTodo(sl()));
  sl.registerLazySingleton(() => GetAllTodos(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
          sl.registerLazySingleton(() => GetPopularCoursesUseCase(repository: sl()));
          sl.registerLazySingleton(() => GetFreshCoursesUseCase(repository: sl()));
          sl.registerLazySingleton(() => GetCourseMainCategoriesUseCase(repository: sl()));
          sl.registerLazySingleton(() => GetCoursesByCategoryUseCase(repository: sl()));
          sl.registerLazySingleton(() => SearchCoursesUseCase(repository: sl()));
          sl.registerLazySingleton(() => GetCourseDetailsUseCase(repository: sl()));
          sl.registerLazySingleton(() => GetQuizzesByCourseIdUseCase(repository: sl()));
          sl.registerLazySingleton(() => GetQuizDetailUseCase(repository: sl()));
          sl.registerLazySingleton(() => SubmitQuizUseCase(repository: sl()));
          sl.registerLazySingleton(() => GetQuizResultsUseCase(repository: sl()));
          sl.registerLazySingleton(() => GetEnrolledCoursesUseCase(repository: sl()));
          sl.registerLazySingleton(() => GetUserProfileUseCase(repository: sl()));
          sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
          sl.registerLazySingleton(() => UpdateProfilePictureUseCase(sl()));
          sl.registerLazySingleton(() => UpdateBioUseCase(sl()));
          sl.registerLazySingleton(() => UpdatePasswordUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
    todoDataSource: sl()
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      dataSource: sl(),
    ),
  );
  sl.registerLazySingleton<CoursesRepository>(
    () => CoursesRepositoryImpl(
      dataSource: sl(),
    ),
  );
  sl.registerLazySingleton<CourseDetailRepository>(
    () => CourseDetailRepositoryImpl(
      dataSource: sl(),
    ),
  );
  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(
      dataSource: sl(),
    ),
  );
  sl.registerLazySingleton<EnrolledCoursesRepository>(
    () => EnrolledCoursesRepositoryImpl(
      dataSource: sl(),
    ),
  );
  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TodoDataSource>(
    () => TodoDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeDataSource>(
    () => HomeDataSourceImpl(),
  );
  sl.registerLazySingleton<CoursesDataSource>(
    () => CoursesDataSourceImpl(),
  );
  sl.registerLazySingleton<CourseDetailDataSource>(
    () => CourseDetailDataSourceImpl(),
  );
  sl.registerLazySingleton<QuizDataSource>(
    () => QuizDataSourceImpl(),
  );
  sl.registerLazySingleton<EnrolledCoursesDataSource>(
    () => EnrolledCoursesDataSourceImpl(),
  );
  sl.registerLazySingleton<UserProfileDataSource>(
    () => UserProfileDataSourceImpl(),
  );

  //! Core
sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
sl.registerLazySingleton<ApiService>(() => ApiService());
}