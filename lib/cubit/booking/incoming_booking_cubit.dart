import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'incoming_booking_state.dart';

class IncomingBookingCubit extends Cubit<IncomingBookingState> {
  final BookingRepository _bookingRepository;
  final SelectedOrganizationCubit _selectedOrganizationCubit;

  late StreamSubscription<List<Booking>?> _bookingSubscription;
  late StreamSubscription<SelectedOrganizationState?> _selectedOrganizationSubscription;

  IncomingBookingCubit({
    required BookingRepository bookingRepository,
    required SelectedOrganizationCubit selectedOrganizationCubit,
  })  : _selectedOrganizationCubit = selectedOrganizationCubit,
        _bookingRepository = bookingRepository,
        super(IncomingBookingState.unknown()) {
    _init();
  }

  _init() {
    if (_selectedOrganizationCubit.state.status == ESelectedOrganizationStatus.succeed) {
      emit(state.copyWith(selectedOrganization: _selectedOrganizationCubit.state.organization));
      _sub();
    }

    _selectedOrganizationSubscription = _selectedOrganizationCubit.stream.listen((event) {
      if (event.status == ESelectedOrganizationStatus.succeed) {
        emit(state.copyWith(selectedOrganization: event.organization));
        _sub();
      } else {
        try {
          _bookingSubscription.cancel();
        } catch (e) {}
        if (state.status != EIncomingStatus.unknown) emit(IncomingBookingState.unknown());
      }
    });
  }

  _sub() async {
    DateTime dateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: -1));

    if (state.selectedOrganization != null)
      _bookingSubscription =
          _bookingRepository.streamIncomingBooking(organizationId: state.selectedOrganization!.id!, dateTime: dateTime).listen((event) {
        if (event.isNotEmpty) emit(state.copyWith(bookings: event, status: EIncomingStatus.succeed));
        if (event.isEmpty) emit(state.copyWith(bookings: event, status: EIncomingStatus.empty));
      });
  }

  @override
  Future<void> close() {
    try {
      _bookingSubscription.cancel();
    } catch (e) {}
    try {
      _selectedOrganizationSubscription.cancel();
    } catch (e) {}

    return super.close();
  }
}
