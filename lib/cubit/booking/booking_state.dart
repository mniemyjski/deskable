part of 'booking_cubit.dart';

enum EBookingStatus { unknown, loading, succeed, empty }

class BookingState extends Equatable {
  final List<Booking>? bookings;
  final DateTime? dateTime;
  final SelectedRoomState? selectedRoomState;
  final EBookingStatus status;

  BookingState({this.bookings, required this.status, this.dateTime, this.selectedRoomState});

  factory BookingState.unknown() {
    return BookingState(status: EBookingStatus.unknown);
  }

  factory BookingState.succeed({required List<Booking> bookings, required DateTime dateTime, required SelectedRoomState selectedRoomState}) {
    return BookingState(status: EBookingStatus.succeed, bookings: bookings, dateTime: dateTime, selectedRoomState: selectedRoomState);
  }

  @override
  List<Object?> get props => [bookings, status, dateTime, selectedRoomState];

  @override
  bool get stringify => true;

  BookingState copyWith({
    List<Booking>? bookings,
    DateTime? dateTime,
    SelectedRoomState? selectedRoomState,
    EBookingStatus? status,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      dateTime: dateTime ?? this.dateTime,
      selectedRoomState: selectedRoomState ?? this.selectedRoomState,
      status: status ?? this.status,
    );
  }
}
