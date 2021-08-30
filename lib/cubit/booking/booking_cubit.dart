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
    emit(BookingState.loading());
    _selectedDateSubscription = _selectedDateCubit.stream.listen((sDate) {
      Logger().e('test $sDate');

      _selectedRoomSubscription = _selectedRoomCubit.stream.listen((sRoom) {
        if (sRoom.status == EStatus.succeed) {
          Logger().e(sRoom.status);

          _bookingRepository.stream(roomId: sRoom.room!.id!, companyId: sRoom.room!.companyId!, dateBook: sDate.dateTime).listen((bookings) async {
            List<Booking> list = [];
            for (var element in bookings!) {
              Account? account = await accountCubit.getAccount(element.userId!);
              list.add(element.copyWith(userName: account?.name ?? '', photoUrl: account?.photoUrl ?? ''));
            }

            emit(BookingState.succeed(list));
          });
        } else {
          emit(BookingState.unknown());
        }
      });
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

  List<String> getListUserRoomBookingInTime({required int time}) {
    List<String> list = [];
    for (var e in state.bookings!) {
      if (e.hoursBook.contains(time)) list.add(e.photoUrl!);
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
