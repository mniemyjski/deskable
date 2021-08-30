import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:equatable/equatable.dart';

part 'selected_room_state.dart';

class SelectedRoomCubit extends Cubit<SelectedRoomState> {
  final RoomCubit _roomCubit;

  SelectedRoomCubit({required RoomCubit roomCubit})
      : _roomCubit = roomCubit,
        super(SelectedRoomState.unknown()) {
    _roomCubit.stream.listen((room) {
      if (room.status == ERoomStatus.succeed) {
        emit(SelectedRoomState.succeed(room: room.rooms.first!));
      } else {
        SelectedRoomState.unknown();
      }
    });
  }
}
