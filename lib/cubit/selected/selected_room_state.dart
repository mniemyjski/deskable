part of 'selected_room_cubit.dart';

class SelectedRoomState extends Equatable {
  final Room? room;
  final EStatus status;

  SelectedRoomState({this.room, required this.status});

  factory SelectedRoomState.unknown() {
    return SelectedRoomState(status: EStatus.unknown);
  }

  factory SelectedRoomState.loading() {
    return SelectedRoomState(status: EStatus.loading);
  }

  factory SelectedRoomState.succeed({required Room room}) {
    return SelectedRoomState(status: EStatus.succeed, room: room);
  }

  @override
  List<Object?> get props => [room, status];
}
