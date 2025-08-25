import 'package:lms/core/error/failures.dart';
import 'package:lms/features/todo/domain/entities/todo.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRepository {
  Future<Either<Failure, Todo>> getTodo(int id);
  Future<Either<Failure,List<Todo>>> getAllTodos();
}

