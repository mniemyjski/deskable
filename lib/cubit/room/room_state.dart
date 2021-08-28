part of 'room_cubit.dart';

abstract class RoomState extends Equatable {
  const RoomState();
}

class RoomInitial extends RoomState {
  @override
  List<Object> get props => [];
}
