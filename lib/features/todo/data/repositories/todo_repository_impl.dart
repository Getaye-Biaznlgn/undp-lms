import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/error/failures.dart';
import 'package:lms/features/todo/data/datasources/todo_data_source.dart';
import 'package:lms/features/todo/data/models/todo_model.dart';
import 'package:lms/features/todo/domain/entities/todo.dart';
import 'package:lms/features/todo/domain/repositories/todo_repository.dart';
import 'package:dartz/dartz.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource todoDataSource;
  
  TodoRepositoryImpl({
    required this.todoDataSource,
  });

  @override
  Future<Either<Failure, Todo>> getTodo(
    int id,
  ) async {
      try{
      final response= await todoDataSource.getTodo(id);
     if(response.success){
       return Right(TodoModel.fromJson(response.data));
     } else{
        return Left(ServerFailure(message: response.error??''));
      }
      }
      catch(exception, stackTrace){
      // Sentry.captureException(exception, stackTrace: stackTrace);
        return const Left(ServerFailure(message: errorMessage));
      }
    }
  

  @override
  Future<Either<Failure,List<Todo>>> getAllTodos() async {
    try{
       final response = await todoDataSource.getAllTodos();
       if(response.success){
         List<TodoModel> todos = response.data.map((json) => TodoModel.fromJson(json)).toList();
       return Right(todos);
       }else{
        return Left(ServerFailure(message: errorMessage));
       }
       
    }catch(exception, stackTrace){
      return Left(ServerFailure(message:errorMessage));
    }
  }
}