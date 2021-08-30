import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
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
    _accountSubscription = _accountCubit.stream.listen((account) {
      if (account.status == EAccountStatus.created) {
        emit(RoomState.loading());
        _selectedCompanyCubit.stream.listen((select) {
          if (select.status == EStatus.succeed) {
            _roomsSubscription = _roomRepository.stream(select.company?.id ?? '').listen((rooms) {
              emit(RoomState.succeed(rooms));
            });
          }
        });
      } else {
        try {
          _roomsSubscription.cancel();
        } catch (e) {
          Failure(message: "Not Initialization");
        }
        emit(RoomState.unknown());
      }
    });
  }

  Future<void> create(Room room) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      return await _roomRepository.create(room);
    }
  }

  @override
  Future<void> close() {
    _roomsSubscription.cancel();
    _accountSubscription.cancel();
    return super.close();
  }
}
