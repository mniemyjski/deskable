import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'room_state.dart';

class RoomCubit extends HydratedCubit<RoomState> {
  final RoomRepository _roomRepository;
  final SelectedCompanyCubit _selectedCompanyCubit;
  final AccountCubit _accountCubit;

  late StreamSubscription<List<Room>> _roomsSubscription;
  late StreamSubscription<AccountState> _accountSubscription;

  RoomCubit({required AccountCubit accountCubit, required RoomRepository roomRepository, required SelectedCompanyCubit selectedCompanyCubit})
      : _roomRepository = roomRepository,
        _selectedCompanyCubit = selectedCompanyCubit,
        _accountCubit = accountCubit,
        super(RoomState.unknown()) {
    _init();
  }

  void _init() {
    if (_selectedCompanyCubit.state.status == ESelectedCompanyStatus.succeed) {
      sub(_selectedCompanyCubit.state);
    }

    _selectedCompanyCubit.stream.listen((event) {
      if (event.status == ESelectedCompanyStatus.succeed) {
        sub(event);
      } else {
        try {
          _roomsSubscription.cancel();
        } catch (e) {}
        if (state.status != ERoomStatus.unknown) emit(RoomState.unknown());
      }
    });
  }

  void sub(SelectedCompanyState selectedCompanyState) {
    try {
      _roomsSubscription.cancel();
    } catch (e) {}
    _roomsSubscription = _roomRepository.stream(selectedCompanyState.company!.id!).listen((rooms) {
      if (rooms.isNotEmpty) {
        rooms.sort((a, b) => a.name.compareTo(b.name));
        if (state.status != ERoomStatus.succeed || rooms.toString() != state.rooms!.toString()) {
          emit(state.copyWith(rooms: rooms, status: ERoomStatus.succeed));
        }
      } else {
        if (state.status != ERoomStatus.empty) emit(state.copyWith(rooms: [], status: ERoomStatus.empty));
      }
    });
  }

  Future<void> delete(Room room) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      return await _roomRepository.delete(room);
    }
  }

  @override
  Future<void> close() {
    try {
      _roomsSubscription.cancel();
    } catch (e) {}
    try {
      _accountSubscription.cancel();
    } catch (e) {}

    return super.close();
  }

  @override
  RoomState? fromJson(Map<String, dynamic> json) {
    return RoomState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(RoomState state) {
    return state.toMap();
  }
}
