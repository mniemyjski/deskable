import 'package:bloc/bloc.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:equatable/equatable.dart';

part 'selected_date_state.dart';

class SelectedDateCubit extends Cubit<SelectedDateState> {
  SelectedDateCubit() : super(SelectedDateState.unknown());

  change(DateTime dateTime) {
    emit(SelectedDateState.loading(dateTime));
    emit(SelectedDateState.succeed(dateTime));
  }

  increase() {
    emit(SelectedDateState.loading(state.dateTime));
    emit(SelectedDateState.succeed(state.dateTime.add(Duration(days: 1))));
  }

  decrease() {
    emit(SelectedDateState.loading(state.dateTime));
    emit(SelectedDateState.succeed(state.dateTime.add(Duration(days: -1))));
  }
}
