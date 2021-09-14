part of 'room_cubit.dart';

enum ERoomStatus { unknown, loading, succeed, empty }

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

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> _rooms = [];
    this.rooms?.forEach((room) {
      _rooms.add(room.toMap());
    });

    return {
      'rooms': _rooms,
      'status': Enums.toText(this.status),
    };
  }

  factory RoomState.fromMap(Map<String, dynamic> map) {
    List<Room> _rooms = [];
    map['rooms'].forEach((room) {
      _rooms.add(Room.fromMap(room));
    });

    return RoomState(
      rooms: _rooms,
      status: Enums.toEnum(map['status'] ?? 'unknown', ERoomStatus.values),
    );
  }
}
