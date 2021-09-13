import 'package:bloc/bloc.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:equatable/equatable.dart';

part 'selected_date_state.dart';

class SelectedDateCubit extends Cubit<SelectedDateState> {
  SelectedDateCubit() : super(SelectedDateState.init());

  change(DateTime dateTime) {
    emit(SelectedDateState.succeed(dateTime, _getDateName(dateTime)));
  }

  increase() {
    emit(SelectedDateState.succeed(state.dateTime.add(Duration(days: 1)), _getDateName(state.dateTime.add(Duration(days: 1)))));
  }

  decrease() {
    emit(SelectedDateState.succeed(state.dateTime.add(Duration(days: -1)), _getDateName(state.dateTime.add(Duration(days: -1)))));
  }

  String _getDateName(DateTime dat) {
    DateTime date = DateTime(dat.year, dat.month, dat.day);
    DateTime dateTimeNow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (date == dateTimeNow) {
      return Languages.today();
      // } else if (date == dateTimeNow.add(Duration(days: 1))) {
      //   return Languages.tomorrow();
      // } else if (date == dateTimeNow.add(Duration(days: -1))) {
      //   return Languages.yesterday();
    } else if (date.weekday == 1) {
      return Languages.monday();
    } else if (date.weekday == 2) {
      return Languages.tuesday();
    } else if (date.weekday == 3) {
      return Languages.wednesday();
    } else if (date.weekday == 4) {
      return Languages.thursday();
    } else if (date.weekday == 5) {
      return Languages.friday();
    } else if (date.weekday == 6) {
      return Languages.saturday();
    } else if (date.weekday == 7) {
      return Languages.sunday();
    } else {
      return '';
    }
  }
}
