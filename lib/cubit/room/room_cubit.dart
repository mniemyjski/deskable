import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  final RoomRepository _roomRepository;
  final SelectedCompanyCubit _selectedCompanyCubit;
  final AccountCubit _accountCubit;

  late StreamSubscription<List<Room>> _roomsSubscription;
  late StreamSubscription<AccountState> _accountSubscription;

  RoomCubit({required AccountCubit accountCubit, required RoomRepository roomRepository, required SelectedCompanyCubit selectedCompanyCubit})
      : _roomRepository = roomRepository,
        _selectedCompanyCubit = selectedCompanyCubit,
        _accountCubit = accountCubit,
        super(RoomState.unknown()) {
    try {
      _roomsSubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }
    try {
      _accountSubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }

    _selectedCompanyCubit.stream.listen((selectedRoom) {
      if (selectedRoom.company != null) test(selectedRoom.company!.id!);
      if (selectedRoom.company == null) {
        try {
          _roomsSubscription.cancel();
        } catch (e) {
          Failure(message: "Not Initialization");
        }
        emit(RoomState.unknown());
      }
    });

    if (state.company == null) emit(state.copyWith(company: _selectedCompanyCubit.state.company));

    if (state.company != null) test(state.company!.id!);
  }

  void test(String id) {
    _roomsSubscription = _roomRepository.stream(id).listen((rooms) {
      emit(state.copyWith(rooms: rooms, status: ERoomStatus.succeed));
    });
  }

  Future<void> create(Room room) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      return await _roomRepository.create(room);
    }
  }

  @override
  Future<void> close() {
    try {
      _roomsSubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }
    try {
      _accountSubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }

    return super.close();
  }
}
