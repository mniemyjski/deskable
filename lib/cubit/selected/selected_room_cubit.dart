import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
part 'selected_room_state.dart';

class SelectedRoomCubit extends Cubit<SelectedRoomState> {
  final RoomCubit _roomCubit;
  late StreamSubscription<RoomState> _roomSubscription;

  SelectedRoomCubit({required RoomCubit roomCubit})
      : _roomCubit = roomCubit,
        super(SelectedRoomState.unknown()) {
    _init();
  }

  void _init() {
    try {
      _roomSubscription.cancel();
    } catch (e) {}

    if (_roomCubit.state.status == ERoomStatus.succeed) {
      emit(SelectedRoomState.succeed(room: _roomCubit.state.rooms!.first));
    }

    _roomSubscription = _roomCubit.stream.listen((room) {
      if (room.status == ERoomStatus.succeed) {
        emit(SelectedRoomState.succeed(room: room.rooms!.first));
      } else if (room.status == ERoomStatus.empty) {
        emit(SelectedRoomState.empty());
      } else {
        emit(SelectedRoomState.unknown());
      }
    });
  }

  @override
  Future<void> close() {
    try {
      _roomSubscription.cancel();
    } catch (e) {}
    return super.close();
  }
}
