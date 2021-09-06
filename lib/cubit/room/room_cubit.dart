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
    _init();
  }

  void _init() {
    if (_selectedCompanyCubit.state.status == EStatus.succeed) {
      _roomsSub(_selectedCompanyCubit.state);
    }

    _selectedCompanyCubit.stream.listen((event) {
      if (event.status == EStatus.succeed) {
        _roomsSub(event);
      } else {
        try {
          _roomsSubscription.cancel();
        } catch (e) {}
        emit(RoomState.unknown());
      }
    });
  }

  void _roomsSub(SelectedCompanyState selectedCompanyState) {
    try {
      _roomsSubscription.cancel();
    } catch (e) {}
    _roomsSubscription = _roomRepository.stream(selectedCompanyState.company!.id!).listen((rooms) {
      if (rooms.isNotEmpty) {
        emit(state.copyWith(rooms: rooms, status: ERoomStatus.succeed));
      } else {
        emit(state.copyWith(rooms: rooms, status: ERoomStatus.empty));
      }
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
    } catch (e) {}
    try {
      _accountSubscription.cancel();
    } catch (e) {}

    return super.close();
  }
}
