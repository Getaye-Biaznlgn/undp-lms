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

  // Use cases
  sl.registerLazySingleton(() => GetTodo(sl()));
  sl.registerLazySingleton(() => GetAllTodos(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetPopularCoursesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetFreshCoursesUseCase(repository: sl()));

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

  //! Core
sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
sl.registerLazySingleton<ApiService>(() => ApiService());
}