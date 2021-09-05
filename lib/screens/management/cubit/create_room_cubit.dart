import 'package:bloc/bloc.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:equatable/equatable.dart';

part 'create_room_state.dart';

class CreateRoomCubit extends Cubit<CreateRoomState> {
  CreateRoomCubit() : super(CreateRoomState.init());

  increaseX() {
    emit(state.copyWith(x: state.x + 1));
  }

  increaseY() {
    emit(state.copyWith(y: state.y + 1));
  }

  decreaseX() {
    if (state.x > 1) emit(state.copyWith(x: state.x - 1));
  }

  decreaseY() {
    if (state.y > 1) emit(state.copyWith(y: state.y - 1));
  }

  addFurniture(Furniture furniture) {
    List<Furniture> a = List.from(state.furniture);
    a.add(furniture);
    emit(state.copyWith(furniture: a));
  }

  removeFurniture(Furniture furniture) {
    List<Furniture> a = List.from(state.furniture);

    a.removeWhere((element) => element.position == furniture.position);
    emit(state.copyWith(furniture: a));
  }

  changeRotation(Furniture furniture, int rotation) {
    List<Furniture> a = List.from(state.furniture);
    a.removeWhere((element) => element.position == furniture.position);
    a.add(furniture.copyWith(rotation: rotation));

    emit(state.copyWith(furniture: a));
  }

  updateNameAndDesc({required Furniture furniture, required String name, required String description}) {
    List<Furniture> a = List.from(state.furniture);
    a.removeWhere((element) => element.position == furniture.position);
    a.add(furniture.copyWith(description: description, name: name));

    emit(state.copyWith(furniture: a));
  }
}
