import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/home/data/models/category_model.dart';
import 'package:lms/features/courses/domain/usecases/get_course_main_categories_usecase.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCourseMainCategoriesUseCase getCourseMainCategoriesUseCase;
  List<CategoryModel> categories = [];

  CategoryBloc({
    required this.getCourseMainCategoriesUseCase,
  }) : super(CategoryInitialState()) {
    on<GetCategoriesEvent>(_onGetCategories);
  }

  Future<void> _onGetCategories(GetCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoadingState());
    final failureOrCategories = await getCourseMainCategoriesUseCase(NoParams());
    failureOrCategories.fold(
      (failure) => emit(CategoryErrorState(message: failure.message)),
      (categoriesList) {
        categories = categoriesList;
        emit(CategoryLoadedState(categories: categoriesList));
      },
    );
  }
}
