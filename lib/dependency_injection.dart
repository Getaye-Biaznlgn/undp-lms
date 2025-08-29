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
import 'package:lms/features/auth/presentation/bloc/auth_bloc.dart';
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
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTodo(sl()));
  sl.registerLazySingleton(() => GetAllTodos(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));

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

  // Data sources
  sl.registerLazySingleton<TodoDataSource>(
    () => TodoDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(),
  );

  //! Core
   sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
 sl.registerLazySingleton<ApiService>(() => ApiService());
}