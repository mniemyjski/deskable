import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'selected_room_state.dart';

class SelectedRoomCubit extends HydratedCubit<SelectedRoomState> {
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
      if (state.status != ESelectedRoomStatus.succeed || _roomCubit.state.rooms!.first != state.room)
        emit(SelectedRoomState.succeed(room: _roomCubit.state.rooms!.first));
    }

    _roomSubscription = _roomCubit.stream.listen((room) {
      if (room.status == ERoomStatus.succeed) {
        if (state.status != ESelectedRoomStatus.succeed || room.rooms!.first != state.room) emit(SelectedRoomState.succeed(room: room.rooms!.first));
      } else if (room.status == ERoomStatus.empty) {
        if (state.status != ESelectedRoomStatus.empty) emit(SelectedRoomState.empty());
      } else {
        if (state.status != ESelectedRoomStatus.unknown) emit(SelectedRoomState.unknown());
      }
    });
  }

  change(Room room) {
    emit(SelectedRoomState.loading());
    emit(SelectedRoomState.succeed(room: room));
  }

  Furniture? getFurniture(String deskId) {
    for (var element in state.room!.furniture) {
      if (element.id == deskId) return element;
    }
  }

  @override
  Future<void> close() {
    try {
      _roomSubscription.cancel();
    } catch (e) {}
    return super.close();
  }

  @override
  SelectedRoomState? fromJson(Map<String, dynamic> json) {
    return SelectedRoomState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SelectedRoomState state) {
    return state.toMap();
  }
}
