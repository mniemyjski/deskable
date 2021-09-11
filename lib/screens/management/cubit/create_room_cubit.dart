import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:equatable/equatable.dart';

part 'create_room_state.dart';

class CreateRoomCubit extends Cubit<CreateRoomState> {
  final RoomRepository _roomRepository;
  final SelectedCompanyCubit _selectedCompanyCubit;
  final AccountCubit _accountCubit;

  CreateRoomCubit({
    required AccountCubit accountCubit,
    required RoomRepository roomRepository,
    required SelectedCompanyCubit selectedCompanyCubit,
  })  : _roomRepository = roomRepository,
        _selectedCompanyCubit = selectedCompanyCubit,
        _accountCubit = accountCubit,
        super(CreateRoomState.init());

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

  increaseOpen() {
    if (state.open < 23 && state.open + 1 < state.close) emit(state.copyWith(open: state.open + 1));
  }

  increaseClose() {
    if (state.close < 23) emit(state.copyWith(close: state.close + 1));
  }

  decreaseOpen() {
    if (state.open > 0) emit(state.copyWith(open: state.open - 1));
  }

  decreaseClose() {
    if (state.close > 0 && state.open < state.close - 1) emit(state.copyWith(close: state.close - 1));
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

  Future<void> create(Room room) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      return await _roomRepository.create(room.copyWith(companyId: _selectedCompanyCubit.state.company!.id));
    }
  }
}
