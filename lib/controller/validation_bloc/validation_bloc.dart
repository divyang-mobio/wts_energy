import 'package:bloc/bloc.dart';

part 'validation_event.dart';

part 'validation_state.dart';

class ValidationBloc extends Bloc<ValidationEvent, ValidationState> {
  ValidationBloc() : super(ValidationInitial()) {
    on<ValidationInComplete>((event, emit) {
      emit(ValidationError());
    });
  }
}
