import 'package:bloc/bloc.dart';

part 'drop_down_event.dart';

part 'drop_down_state.dart';

class DropDownBloc extends Bloc<DropDownEvent, DropDownState> {
  DropDownBloc() : super(DropDownInitial()) {
    on<SelectValue>((event, emit) {
      emit(DropDownSelectedValue());
    });
  }
}
