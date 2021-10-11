import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'month_booking_state.dart';

class MonthBookingCubit extends Cubit<MonthBookingState> {
  MonthBookingCubit() : super(MonthBookingInitial());
}
