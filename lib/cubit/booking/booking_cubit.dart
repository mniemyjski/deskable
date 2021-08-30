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
    if (_selectedRoomCubit.state.status == EStatus.succeed) {
      emit(BookingState.loading());
      _bookingRepository
          .stream(
        roomId: _selectedRoomCubit.state.room!.id!,
        companyId: _selectedRoomCubit.state.room!.companyId!,
        dateBook: _selectedDateCubit.state.dateTime,
      )
          .listen((bookings) async {
        List<Booking> list = [];
        for (var element in bookings!) {
          String name = await accountCubit.getName(element.userId!);
          list.add(element.copyWith(userName: name));
        }

        emit(BookingState.succeed(list));
      });
    } else {
      BookingState.unknown();
    }
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
}
