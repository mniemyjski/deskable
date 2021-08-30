part of 'booking_cubit.dart';

class BookingState extends Equatable {
  final List<Booking>? bookings;
  final DateTime? dateTime;
  final Room? selectedRoom;
  final EStatus status;

  BookingState({this.bookings, required this.status, this.dateTime, this.selectedRoom});

  factory BookingState.unknown() {
    return BookingState(status: EStatus.unknown);
  }

  factory BookingState.succeed({required List<Booking> bookings, required DateTime dateTime, required Room selectedRoom}) {
    return BookingState(status: EStatus.succeed, bookings: bookings, dateTime: dateTime, selectedRoom: selectedRoom);
  }

  @override
  List<Object?> get props => [bookings, status, dateTime, selectedRoom];

  BookingState copyWith({
    List<Booking>? bookings,
    DateTime? dataTime,
    Room? selectedRoom,
    EStatus? status,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      dateTime: dataTime ?? this.dateTime,
      selectedRoom: selectedRoom ?? this.selectedRoom,
      status: status ?? this.status,
    );
  }
}
