part of 'category_bloc.dart';

abstract class CategoryState {}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<CategoryModel> categories;
  CategoryLoadedState({required this.categories});
}

class CategoryErrorState extends CategoryState {
  final String message;
  CategoryErrorState({required this.message});
}
