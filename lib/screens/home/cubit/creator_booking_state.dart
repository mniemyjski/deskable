part of 'creator_booking_cubit.dart';

class CreatorBookingState extends Equatable {
  final Booking booking;
  final EStatus status;

  CreatorBookingState({required this.booking, required this.status});

  factory CreatorBookingState.unknown() {
    return CreatorBookingState(booking: Booking(hoursBook: []), status: EStatus.unknown);
  }

  factory CreatorBookingState.loading() {
    return CreatorBookingState(booking: Booking(hoursBook: []), status: EStatus.loading);
  }

  factory CreatorBookingState.succeed(Booking booking) {
    return CreatorBookingState(booking: booking, status: EStatus.succeed);
  }

  @override
  List<Object> get props => [booking, status];
}
