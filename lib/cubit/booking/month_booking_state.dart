part of 'month_booking_cubit.dart';

enum EMonthBookingStatus { unknown, loading, succeed, empty }

class MonthBookingState extends Equatable {
  final List<Booking> bookings;
  final Organization? selectedOrganization;
  final Account? account;
  final EMonthBookingStatus status;

  MonthBookingState({required this.bookings, this.selectedOrganization, this.account, required this.status});

  factory MonthBookingState.unknown() {
    return MonthBookingState(bookings: [], status: EMonthBookingStatus.unknown);
  }

  @override
  List<Object?> get props => [bookings, selectedOrganization, account, status];

  MonthBookingState copyWith({
    List<Booking>? bookings,
    Organization? selectedOrganization,
    Account? account,
    EMonthBookingStatus? status,
  }) {
    return MonthBookingState(
      bookings: bookings ?? this.bookings,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      account: account ?? this.account,
      status: status ?? this.status,
    );
  }
}
