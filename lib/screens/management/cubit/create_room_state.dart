part of 'create_room_cubit.dart';

class CreateRoomState extends Equatable {
  final int x;
  final int y;
  final List<Furniture> furniture;
  final int open;
  final int close;

  CreateRoomState({required this.x, required this.y, required this.furniture, required this.open, required this.close});

  factory CreateRoomState.init() {
    return CreateRoomState(x: 5, y: 5, furniture: [], open: 6, close: 23);
  }

  @override
  List<Object> get props => [x, y, furniture, open, close];

  CreateRoomState copyWith({
    int? x,
    int? y,
    List<Furniture>? furniture,
    int? open,
    int? close,
  }) {
    return CreateRoomState(
      x: x ?? this.x,
      y: y ?? this.y,
      furniture: furniture ?? this.furniture,
      open: open ?? this.open,
      close: close ?? this.close,
    );
  }
}
