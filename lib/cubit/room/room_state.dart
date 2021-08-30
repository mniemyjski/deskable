part of 'room_cubit.dart';

enum ERoomStatus { unknown, loading, succeed }

class RoomState extends Equatable {
  final List<Room?> rooms;
  final ERoomStatus status;

  const RoomState({required this.rooms, required this.status});

  factory RoomState.unknown() {
    return RoomState(rooms: [], status: ERoomStatus.unknown);
  }

  factory RoomState.loading() {
    return RoomState(rooms: [], status: ERoomStatus.loading);
  }
  factory RoomState.succeed(List<Room> rooms) {
    return RoomState(rooms: rooms, status: ERoomStatus.succeed);
  }

  @override
  List<Object?> get props => [rooms, status];
}
