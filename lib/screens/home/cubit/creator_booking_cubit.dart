import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/booking_model.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'creator_booking_state.dart';

class CreatorBookingCubit extends Cubit<CreatorBookingState> {
  final SelectedDateCubit _selectedDateCubit;
  final SelectedRoomCubit _selectedRoomCubit;
  final BookingCubit _bookingCubit;

  CreatorBookingCubit({
    required SelectedDateCubit selectedDateCubit,
    required SelectedRoomCubit selectedRoomCubit,
    required BookingCubit bookingCubit,
  })  : _selectedDateCubit = selectedDateCubit,
        _selectedRoomCubit = selectedRoomCubit,
        _bookingCubit = bookingCubit,
        super(CreatorBookingState.unknown());

  void init(String deskId) {
    Booking? already = _bookingCubit.getMyBooking(deskId: deskId);
    Booking booking;
    if (already == null) {
      booking = Booking(
        companyId: _selectedRoomCubit.state.room!.companyId,
        roomId: _selectedRoomCubit.state.room!.id,
        deskId: deskId,
        dateBook: _selectedDateCubit.state.dateTime,
        hoursBook: [],
      );
    } else {
      booking = already;
    }

    emit(CreatorBookingState.succeed(booking));
  }

  void add(int hour) {
    if (!state.booking.hoursBook.contains(hour)) {
      state.booking.hoursBook.add(hour);
      emit(state);
    }
  }

  void remove(int hour) {
    state.booking.hoursBook.remove(hour);
    emit(state);
  }
}
