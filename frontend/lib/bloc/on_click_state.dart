part of 'on_click_bloc.dart';

@immutable
abstract class OnClickState {}

class OnClickInitial extends OnClickState {
  final bool onClick;

  OnClickInitial(this.onClick);
}
