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
    try {
      _roomSubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }
    _roomSubscription = _roomCubit.stream.listen((room) {
      if (room.status == ERoomStatus.succeed) {
        emit(SelectedRoomState.succeed(room: room.rooms!.first));
      } else {
        emit(SelectedRoomState.unknown());
      }
    });
  }

  @override
  Future<void> close() {
    try {
      _roomSubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }
    return super.close();
  }
}
