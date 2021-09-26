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
    Booking? booking = _bookingCubit.getMyBooking(deskId: deskId);

    booking = Booking(
      id: booking?.id,
      userId: booking?.userId,
      organizationId: _selectedRoomCubit.state.room!.organizationId,
      roomId: _selectedRoomCubit.state.room!.id,
      furnitureId: deskId,
      dateBooked: _selectedDateCubit.state.dateTime,
      hoursBooked: List.from(_bookingCubit.getMyBooking(deskId: deskId)?.hoursBooked ?? []),
    );

    emit(CreatorBookingState.succeed(booking));
  }

  void add(int hour) {
    if (!state.booking.hoursBooked.contains(hour)) {
      state.booking.hoursBooked.add(hour);
      emit(state);
    }
  }

  void remove(int hour) {
    state.booking.hoursBooked.remove(hour);
    emit(state);
  }
}
