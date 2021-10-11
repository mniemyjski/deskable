import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'incoming_booking_state.dart';

class IncomingBookingCubit extends Cubit<IncomingBookingState> {
  final BookingRepository _bookingRepository;
  final AccountCubit _accountCubit;
  final SelectedOrganizationCubit _selectedOrganizationCubit;

  late StreamSubscription<List<Booking>?> _bookingSubscription;
  late StreamSubscription<AccountState?> _accountSubscription;
  late StreamSubscription<SelectedOrganizationState?> _selectedOrganizationSubscription;

  IncomingBookingCubit({
    required BookingRepository bookingRepository,
    required SelectedOrganizationCubit selectedOrganizationCubit,
    required AccountCubit accountCubit,
  })  : _selectedOrganizationCubit = selectedOrganizationCubit,
        _bookingRepository = bookingRepository,
        _accountCubit = accountCubit,
        super(IncomingBookingState.unknown()) {
    _init();
  }

  _init() {
    if (_selectedOrganizationCubit.state.status == ESelectedOrganizationStatus.succeed) {
      emit(state.copyWith(selectedOrganization: _selectedOrganizationCubit.state.organization));
      _sub();
    }

    if (_accountCubit.state.status == EAccountStatus.created) {
      emit(state.copyWith(account: _accountCubit.state.account));
      _sub();
    }

    _accountSubscription = _accountCubit.stream.listen((event) {
      if (event.status == EAccountStatus.created) {
        emit(state.copyWith(account: event.account));
        _sub();
      } else {
        try {
          _bookingSubscription.cancel();
        } catch (e) {}
        if (state.status != EIncomingStatus.unknown) emit(IncomingBookingState.unknown());
      }
    });

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
    if (state.selectedOrganization != null && state.account != null)
      _bookingSubscription =
          _bookingRepository.streamIncomingBooking(organizationId: state.selectedOrganization!.id!, userId: state.account!.uid).listen((event) {
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
      _accountSubscription.cancel();
    } catch (e) {}
    try {
      _selectedOrganizationSubscription.cancel();
    } catch (e) {}

    return super.close();
  }
}
