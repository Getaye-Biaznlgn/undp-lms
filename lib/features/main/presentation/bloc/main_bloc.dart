import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainState(selectedIndex: 0)) {
    on<ChangeTab>(_onChangeTab);
  }

  void _onChangeTab(ChangeTab event, Emitter<MainState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }
}
