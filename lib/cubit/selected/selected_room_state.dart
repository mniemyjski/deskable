part of 'selected_room_cubit.dart';

enum ESelectedRoomStatus { unknown, loading, succeed, empty }

class SelectedRoomState extends Equatable {
  final Room? room;
  final ESelectedRoomStatus status;

  SelectedRoomState({this.room, required this.status});

  factory SelectedRoomState.unknown() {
    return SelectedRoomState(status: ESelectedRoomStatus.unknown);
  }

  factory SelectedRoomState.loading() {
    return SelectedRoomState(status: ESelectedRoomStatus.loading);
  }

  factory SelectedRoomState.empty() {
    return SelectedRoomState(status: ESelectedRoomStatus.empty);
  }

  factory SelectedRoomState.succeed({required Room room}) {
    return SelectedRoomState(status: ESelectedRoomStatus.succeed, room: room);
  }

  @override
  List<Object?> get props => [room, status];
}
