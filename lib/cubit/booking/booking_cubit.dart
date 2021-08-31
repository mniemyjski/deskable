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
    try {
      _selectedDateSubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }
    _selectedDateSubscription = _selectedDateCubit.stream.listen((sDate) {
      emit(state.copyWith(dataTime: sDate.dateTime));
      if (state.dateTime != null && state.selectedRoom != null) test(accountCubit);
    });
    try {
      _selectedRoomSubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }
    _selectedRoomSubscription = _selectedRoomCubit.stream.listen((sRoom) {
      if (state.dateTime == null) {
        emit(state.copyWith(dataTime: _selectedDateCubit.state.dateTime));
      }
      if (sRoom.status == EStatus.succeed) {
        emit(state.copyWith(selectedRoom: sRoom.room));
        if (state.dateTime != null && state.selectedRoom != null) test(accountCubit);
      } else {
        // try {
        //   _selectedRoomSubscription.cancel();
        // } catch (e) {
        //   Failure(message: "Not Initialization");
        // }
        try {
          _bookingSubscription.cancel();
        } catch (e) {
          Failure(message: "Not Initialization");
        }
        emit(BookingState.unknown());
      }
    });

    if (state.dateTime == null) {
      emit(state.copyWith(dataTime: _selectedDateCubit.state.dateTime));
    }
    if (state.selectedRoom == null) {
      emit(state.copyWith(selectedRoom: selectedRoomCubit.state.room));
    }

    if (state.dateTime != null && state.selectedRoom != null) test(accountCubit);
  }

  Future<void> test(AccountCubit accountCubit) async {
    try {
      _bookingSubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }
    Logger().wtf('${state.selectedRoom!.id!} ${state.selectedRoom!.companyId!} ${state.dateTime}');
    _bookingSubscription = _bookingRepository
        .stream(roomId: state.selectedRoom!.id!, companyId: state.selectedRoom!.companyId!, dateBook: state.dateTime!)
        .listen((bookings) async {
      List<Booking> list = [];

      for (var element in bookings!) {
        Account? account = await accountCubit.getAccount(element.userId!);
        list.add(element.copyWith(userName: account?.name ?? '', photoUrl: account?.photoUrl ?? ''));
      }
      emit(state.copyWith(bookings: list, status: EStatus.succeed));
    });
  }

  Future<void> create(Booking booking) async {
    return await _bookingRepository.create(booking.copyWith(userId: _accountCubit.state.account!.uid));
  }

  Booking? getBooking({required int deskId, required int hour}) {
    return state.bookings!.firstWhereOrNull(
        (element) => element.deskId == deskId && element.hoursBook.contains(hour) && element.dateBook == _selectedDateCubit.state.dateTime);
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
    _bookingSubscription.cancel();
    _selectedDateSubscription.cancel();
    _selectedRoomSubscription.cancel();
    return super.close();
  }
}
