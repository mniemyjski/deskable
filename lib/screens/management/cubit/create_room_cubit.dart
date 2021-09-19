import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:collection/collection.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:equatable/equatable.dart';

part 'create_room_state.dart';

class CreateRoomCubit extends Cubit<CreateRoomState> {
  final RoomRepository _roomRepository;
  final SelectedOrganizationCubit _selectedCompanyCubit;
  final AccountCubit _accountCubit;

  CreateRoomCubit({
    required AccountCubit accountCubit,
    required RoomRepository roomRepository,
    required SelectedOrganizationCubit selectedCompanyCubit,
  })  : _roomRepository = roomRepository,
        _selectedCompanyCubit = selectedCompanyCubit,
        _accountCubit = accountCubit,
        super(CreateRoomState.init());

  init(Room? room) {
    emit(CreateRoomState.init(room: room));
  }

  increaseX() {
    if (state.room.x < 25) emit(state.copyWith(room: state.room.copyWith(x: state.room.x + 1)));
  }

  increaseY() {
    if (state.room.y < 25) emit(state.copyWith(room: state.room.copyWith(y: state.room.y + 1)));
  }

  decreaseX() {
    if (state.room.x > 2) emit(state.copyWith(room: state.room.copyWith(x: state.room.x - 1)));
  }

  decreaseY() {
    if (state.room.y > 2) emit(state.copyWith(room: state.room.copyWith(y: state.room.y - 1)));
  }

  increaseOpen() {
    if (state.room.open < 23 && state.room.open + 1 < state.room.close) emit(state.copyWith(room: state.room.copyWith(open: state.room.open + 1)));
  }

  increaseClose() {
    if (state.room.close < 24) emit(state.copyWith(room: state.room.copyWith(close: state.room.close + 1)));
  }

  decreaseOpen() {
    if (state.room.open > 0) emit(state.copyWith(room: state.room.copyWith(open: state.room.open - 1)));
  }

  decreaseClose() {
    if (state.room.close > 0 && state.room.open < state.room.close - 1) emit(state.copyWith(room: state.room.copyWith(close: state.room.close - 1)));
  }

  addFurniture(Furniture furniture) {
    List<Furniture> a = List.from(state.room.furniture);
    a.add(furniture);
    emit(state.copyWith(room: state.room.copyWith(furniture: a)));
  }

  removeFurniture(Furniture furniture) {
    List<Furniture> a = List.from(state.room.furniture);
    a.removeWhere((element) => element.position == furniture.position);

    emit(state.copyWith(room: state.room.copyWith(furniture: a)));
  }

  changeRotation(Furniture furniture, int rotation) {
    List<Furniture> a = List.from(state.room.furniture);
    a.removeWhere((element) => element.position == furniture.position);
    a.add(furniture.copyWith(rotation: rotation));

    emit(state.copyWith(room: state.room.copyWith(furniture: a)));
  }

  updateNameAndDesc({required Furniture furniture, required String name, required String description}) {
    List<Furniture> a = List.from(state.room.furniture);
    a.removeWhere((element) => element.position == furniture.position);
    a.add(furniture.copyWith(description: description, name: name));

    emit(state.copyWith(room: state.room.copyWith(furniture: a)));
  }

  Future<void> create({required String name, required String description}) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      return await _roomRepository.create(state.room.copyWith(
        organizationId: _selectedCompanyCubit.state.organization!.id,
        name: name,
        description: description,
      ));
    }
  }

  Future<void> update({required String name, required String description}) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      return await _roomRepository.update(state.room.copyWith(
        organizationId: _selectedCompanyCubit.state.organization!.id,
        name: name,
        description: description,
      ));
    }
  }

  bool isFree(int position) {
    Furniture? furniture = state.room.furniture.firstWhereOrNull((element) => element.position == position);

    return furniture != null ? false : true;
  }
}
