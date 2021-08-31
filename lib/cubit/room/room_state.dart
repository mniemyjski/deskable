part of 'room_cubit.dart';

enum ERoomStatus { unknown, loading, succeed }

class RoomState extends Equatable {
  final List<Room>? rooms;
  final Company? company;
  final ERoomStatus status;

  const RoomState({required this.rooms, this.company, required this.status});

  factory RoomState.unknown() {
    return RoomState(rooms: [], status: ERoomStatus.unknown);
  }

  @override
  List<Object?> get props => [rooms, status];

  RoomState copyWith({
    List<Room>? rooms,
    Company? company,
    ERoomStatus? status,
  }) {
    return RoomState(
      rooms: rooms ?? this.rooms,
      company: company ?? this.company,
      status: status ?? this.status,
    );
  }
}
