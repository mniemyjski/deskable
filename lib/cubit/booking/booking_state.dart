part of 'booking_cubit.dart';

class BookingState extends Equatable {
  final List<Booking>? bookings;
  final EStatus status;

  BookingState({this.bookings, required this.status});

  factory BookingState.unknown() {
    return BookingState(status: EStatus.unknown);
  }

  factory BookingState.loading() {
    return BookingState(status: EStatus.loading);
  }

  factory BookingState.succeed(List<Booking> bookings) {
    return BookingState(status: EStatus.succeed, bookings: bookings);
  }

  @override
  List<Object?> get props => [bookings, status];
}
