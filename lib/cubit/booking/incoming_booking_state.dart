part of 'incoming_booking_cubit.dart';

enum EIncomingStatus { unknown, loading, succeed, empty }

class IncomingBookingState extends Equatable {
  final List<Booking> bookings;
  final Organization? selectedOrganization;
  final EIncomingStatus status;

  IncomingBookingState({required this.bookings, this.selectedOrganization, required this.status});

  factory IncomingBookingState.unknown() {
    return IncomingBookingState(bookings: [], status: EIncomingStatus.unknown);
  }

  @override
  List<Object?> get props => [bookings, selectedOrganization, status];

  IncomingBookingState copyWith({
    List<Booking>? bookings,
    Organization? selectedOrganization,
    EIncomingStatus? status,
  }) {
    return IncomingBookingState(
      bookings: bookings ?? this.bookings,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      status: status ?? this.status,
    );
  }
}
