import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'on_click_event.dart';
part 'on_click_state.dart';

class OnClickBloc extends Bloc<OnClickEvent, OnClickInitial> {
  OnClickBloc() : super(OnClickInitial(true)) {
    on<OnClickDataEvent>((event, emit) {
      emit(OnClickInitial(event.onClick));
    });
  }
}
