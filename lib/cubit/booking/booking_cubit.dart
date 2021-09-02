import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _bookingRepository;
  final AccountCubit _accountCubit;
  final SelectedRoomCubit _selectedRoomCubit;
  final SelectedDateCubit _selectedDateCubit;

  late StreamSubscription<List<Booking>?> _bookingSubscription;
  late StreamSubscription<SelectedRoomState?> _selectedRoomSubscription;
  late StreamSubscription<SelectedDateState?> _selectedDateSubscription;

  List<Account> accounts = [];
  BookingCubit({
    required BookingRepository bookingRepository,
    required AccountCubit accountCubit,
    required SelectedRoomCubit selectedRoomCubit,
    required SelectedDateCubit selectedDateCubit,
  })  : _accountCubit = accountCubit,
        _bookingRepository = bookingRepository,
        _selectedRoomCubit = selectedRoomCubit,
        _selectedDateCubit = selectedDateCubit,
        super(BookingState.unknown()) {
    _init();
  }

  void _init() {
    if (_selectedDateCubit.state.status == EStatus.succeed) {
      emit(state.copyWith(dateTime: _selectedDateCubit.state.dateTime));
    }

    if (_selectedRoomCubit.state.status == EStatus.succeed) {
      emit(state.copyWith(selectedRoomState: _selectedRoomCubit.state));
    }

    _bookingSub();

    _selectedDateSubscription = _selectedDateCubit.stream.listen((event) {
      if (event.status == EStatus.succeed) {
        emit(state.copyWith(dateTime: event.dateTime));
        _bookingSub();
      } else {
        try {
          _bookingSubscription.cancel();
        } catch (e) {}
        emit(BookingState(status: EStatus.unknown, selectedRoomState: state.selectedRoomState));
      }
    });

    _selectedRoomSubscription = _selectedRoomCubit.stream.listen((event) {
      if (event.status == EStatus.succeed) {
        emit(state.copyWith(selectedRoomState: event));
        _bookingSub();
      } else {
        try {
          _bookingSubscription.cancel();
        } catch (e) {}

        emit(BookingState(status: EStatus.unknown, dateTime: state.dateTime));
      }
    });
  }

  Future<void> _bookingSub() async {
    try {
      _bookingSubscription.cancel();
    } catch (e) {}
    if (state.dateTime != null && (state.selectedRoomState?.status ?? EStatus.unknown) == EStatus.succeed) {
      emit(state.copyWith(status: EStatus.loading));
      _bookingSubscription = _bookingRepository
          .stream(roomId: state.selectedRoomState!.room!.id!, companyId: state.selectedRoomState!.room!.companyId!, dateBook: state.dateTime!)
          .listen((bookings) async {
        List<Booking> list = [];
        for (var element in bookings!) {
          if (accounts.contains(element.userId!)) {
            Account account = accounts.firstWhere((e) => e.uid == element.userId);
            list.add(element.copyWith(userName: account.name, photoUrl: account.photoUrl));
          } else {
            if (_accountCubit.state.status == EAccountStatus.created) {
              Account? account = await _accountCubit.getAccount(element.userId!);

              if (account != null) accounts.add(account);
              list.add(element.copyWith(userName: account?.name ?? '', photoUrl: account?.photoUrl ?? ''));
            }
          }
        }
        emit(state.copyWith(bookings: List.from(list), status: EStatus.succeed));
        list.clear();
      });
    } else {
      try {
        _bookingSubscription.cancel();
      } catch (e) {}

      emit(BookingState.unknown());
    }
  }

  Future<void> create(Booking booking) async {
    return await _bookingRepository.create(booking.copyWith(userId: _accountCubit.state.account!.uid));
  }

  Future<void> delete(Booking booking) async {
    return await _bookingRepository.delete(booking);
  }

  Booking? getBooking({required int deskId, required int hour}) {
    return state.bookings!
        .firstWhereOrNull((element) => element.deskId == deskId && element.hoursBook.contains(hour) && element.dateBook == state.dateTime);
  }

  bool available({required int deskId, required int hour}) {
    Booking? booking = state.bookings!
        .firstWhereOrNull((element) => element.deskId == deskId && element.hoursBook.contains(hour) && element.dateBook == state.dateTime);

    Logger().e(state.bookings);
    bool available = booking == null ? true : false;

    return available;
  }

  Booking? getMyBooking({required int deskId}) {
    return state.bookings!.firstWhereOrNull((element) =>
        element.userId == _accountCubit.state.account!.uid && element.dateBook == _selectedDateCubit.state.dateTime && element.deskId == deskId);
  }

  List<String> getListUserRoomBookingInTime({required int time, required bool name}) {
    List<String> list = [];
    for (var e in state.bookings!) {
      if (e.hoursBook.contains(time)) name ? list.add(e.photoUrl!) : list.add(e.userName!);
    }
    return list;
  }

  @override
  Future<void> close() {
    try {
      _bookingSubscription.cancel();
    } catch (e) {}
    try {
      _selectedDateSubscription.cancel();
    } catch (e) {}
    try {
      _selectedRoomSubscription.cancel();
    } catch (e) {}

    return super.close();
  }
}
