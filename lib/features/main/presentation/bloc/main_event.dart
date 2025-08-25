part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class ChangeTab extends MainEvent {
  final int index;

  const ChangeTab(this.index);

  @override
  List<Object> get props => [index];
}
