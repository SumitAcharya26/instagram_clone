part of 'on_click_bloc.dart';

@immutable
abstract class OnClickEvent {}

class OnClickDataEvent extends OnClickEvent {

  final bool onClick;

  OnClickDataEvent(this.onClick);

}