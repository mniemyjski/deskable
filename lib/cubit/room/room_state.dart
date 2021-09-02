part of 'room_cubit.dart';

enum ERoomStatus { unknown, loading, succeed }

class RoomState extends Equatable {
  final List<Room>? rooms;
  final ERoomStatus status;

  const RoomState({required this.rooms, required this.status});

  factory RoomState.unknown() {
    return RoomState(rooms: [], status: ERoomStatus.unknown);
  }

  @override
  List<Object?> get props => [rooms, status];

  RoomState copyWith({
    List<Room>? rooms,
    ERoomStatus? status,
  }) {
    return RoomState(
      rooms: rooms ?? this.rooms,
      status: status ?? this.status,
    );
  }
}
