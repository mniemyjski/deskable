part of 'creator_booking_cubit.dart';

enum ECreatorBookingStatus { unknown, loading, succeed }

class CreatorBookingState extends Equatable {
  final Booking booking;
  final ECreatorBookingStatus status;

  CreatorBookingState({required this.booking, required this.status});

  factory CreatorBookingState.unknown() {
    return CreatorBookingState(booking: Booking(hoursBooked: []), status: ECreatorBookingStatus.unknown);
  }

  factory CreatorBookingState.loading() {
    return CreatorBookingState(booking: Booking(hoursBooked: []), status: ECreatorBookingStatus.loading);
  }

  factory CreatorBookingState.succeed(Booking booking) {
    return CreatorBookingState(booking: booking, status: ECreatorBookingStatus.succeed);
  }

  @override
  List<Object> get props => [booking, status];
}
