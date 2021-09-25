import 'dart:async';

import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'booking_state.dart';

class BookingCubit extends HydratedCubit<BookingState> {
  final BookingRepository _bookingRepository;
  final AccountRepository _accountRepository;
  final AccountCubit _accountCubit;
  final SelectedRoomCubit _selectedRoomCubit;
  final SelectedDateCubit _selectedDateCubit;

  late StreamSubscription<List<Booking>?> _bookingSubscription;
  late StreamSubscription<SelectedRoomState?> _selectedRoomSubscription;
  late StreamSubscription<SelectedDateState?> _selectedDateSubscription;

  List<Account> accounts = [];
  BookingCubit(
      {required BookingRepository bookingRepository,
      required AccountCubit accountCubit,
      required SelectedRoomCubit selectedRoomCubit,
      required SelectedDateCubit selectedDateCubit,
      required AccountRepository accountRepository})
      : _accountCubit = accountCubit,
        _bookingRepository = bookingRepository,
        _selectedRoomCubit = selectedRoomCubit,
        _selectedDateCubit = selectedDateCubit,
        _accountRepository = accountRepository,
        super(BookingState.unknown()) {
    _init();
  }

  void _init() {
    if (_selectedDateCubit.state.status == ESelectedDateStatus.succeed) {
      if (_selectedDateCubit.state.dateTime != state.dateTime) emit(state.copyWith(dateTime: _selectedDateCubit.state.dateTime));
    }

    if (_selectedRoomCubit.state.status == ESelectedRoomStatus.succeed) {
      if (_selectedRoomCubit.state != state.selectedRoomState) emit(state.copyWith(selectedRoomState: _selectedRoomCubit.state));
    }

    _sub();

    _selectedDateSubscription = _selectedDateCubit.stream.listen((event) {
      if (event.status == ESelectedDateStatus.succeed) {
        if (event.dateTime != state.dateTime) {
          emit(state.copyWith(dateTime: event.dateTime));
          _sub();
        }
      } else {
        try {
          _bookingSubscription.cancel();
        } catch (e) {}
        emit(BookingState(status: EBookingStatus.unknown, selectedRoomState: state.selectedRoomState));
      }
    });

    try {
      _selectedRoomSubscription.cancel();
    } catch (e) {}
    _selectedRoomSubscription = _selectedRoomCubit.stream.listen((event) {
      if (event.status == ESelectedRoomStatus.succeed) {
        if (event != state.selectedRoomState) {
          emit(state.copyWith(selectedRoomState: event));
          _sub();
        }
      } else {
        try {
          _bookingSubscription.cancel();
        } catch (e) {}

        emit(BookingState(status: EBookingStatus.unknown, dateTime: state.dateTime));
      }
    });
  }

  Future<void> _sub() async {
    try {
      _bookingSubscription.cancel();
    } catch (e) {}
    if (state.dateTime != null && (state.selectedRoomState?.status ?? ESelectedRoomStatus.unknown) == ESelectedRoomStatus.succeed) {
      emit(state.copyWith(status: EBookingStatus.loading));
      _bookingSubscription = _bookingRepository
          .stream(roomId: state.selectedRoomState!.room!.id!, companyId: state.selectedRoomState!.room!.organizationId!, dateBook: state.dateTime!)
          .listen((bookings) async {
        List<Booking> _bookings = await _buildBooking(bookings!);
        emit(state.copyWith(bookings: List.from(_bookings), status: EBookingStatus.succeed));
      });
    } else {
      try {
        _bookingSubscription.cancel();
      } catch (e) {}
      if (state.status != EBookingStatus.unknown) emit(BookingState.unknown());
    }
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

  Future<List<Booking>> _buildBooking(List<Booking> bookings) async {
    List<Booking> list = [];
    for (var element in bookings) {
      if (accounts.contains(element.userId!)) {
        Account account = accounts.firstWhere((e) => e.uid == element.userId);
        list.add(element.copyWith(account: account));
      } else {
        if (_accountCubit.state.status == EAccountStatus.created) {
          Account? account = await _accountRepository.getAccountById(element.userId!);

          if (account != null) accounts.add(account);
          list.add(element.copyWith(account: account));
        }
      }
    }
    return list;
  }

  Future<void> create(Booking booking) async {
    return await _bookingRepository.create(booking.copyWith(userId: _accountCubit.state.account!.uid));
  }

  Future<void> delete(Booking booking) async {
    return await _bookingRepository.delete(booking);
  }

  Booking? getBooking({required String deskId, required int hour}) {
    return state.bookings!.firstWhereOrNull((element) =>
        element.roomId == _selectedRoomCubit.state.room!.id &&
        element.deskId == deskId &&
        element.hoursBook.contains(hour) &&
        element.dateBook == state.dateTime);
  }

  bool alreadyBookedOtherUser(Booking booking) {
    bool available = true;

    booking.hoursBook.forEach((hour) {
      Booking? already = getBooking(deskId: booking.deskId!, hour: hour);
      if (already != null) {
        if (booking.id != already.id) available = false;
      }
    });

    return available;
  }

  bool alreadyBookedInOtherDesk(Booking booking) {
    bool available = true;

    List<Booking> bookings = [];
    bookings = state.bookings!
        .where((element) =>
            element.userId == _accountCubit.state.account!.uid &&
            element.dateBook == _selectedDateCubit.state.dateTime &&
            element.deskId != booking.deskId)
        .toList();

    booking.hoursBook.forEach((hour) {
      bookings.forEach((element) {
        if (element.hoursBook.contains(hour)) available = false;
      });
    });

    return available;
  }

  Booking? getMyBooking({required String deskId}) {
    return state.bookings!.firstWhereOrNull((element) =>
        element.userId == _accountCubit.state.account!.uid && element.dateBook == _selectedDateCubit.state.dateTime && element.deskId == deskId);
  }

  List<Account> getListUserRoomBookingInTime(int time) {
    List<Account> list = [];
    for (var e in state.bookings!) {
      if (e.hoursBook.contains(time) && e.roomId == _selectedRoomCubit.state.room!.id) list.add(e.account!);
    }
    return list;
  }

  String? getDeskIdInTime({required int time, required Account account}) {
    for (var e in state.bookings!) {
      if (e.hoursBook.contains(time) && e.account!.uid == account.uid && e.roomId == _selectedRoomCubit.state.room!.id) return e.deskId!;
    }
  }

  @override
  BookingState? fromJson(Map<String, dynamic> json) {
    return BookingState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(BookingState state) {
    return state.toMap();
  }
}
