part of 'create_room_cubit.dart';

class CreateRoomState extends Equatable {
  final Room room;
  final bool edit;

  CreateRoomState({required this.room, required this.edit});

  factory CreateRoomState.init({Room? room}) {
    if (room == null) {
      return CreateRoomState(room: Room(x: 5, y: 5, open: 6, close: 24, furniture: [], name: ''), edit: false);
    } else {
      return CreateRoomState(room: room, edit: true);
    }
  }

  @override
  List<Object> get props => [room];

  CreateRoomState copyWith({
    Room? room,
    bool? edit,
  }) {
    return CreateRoomState(
      room: room ?? this.room,
      edit: edit ?? this.edit,
    );
  }
}
