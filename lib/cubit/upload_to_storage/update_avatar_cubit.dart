import 'dart:typed_data';

import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_avatar_state.dart';

class UpdateAvatarCubit extends Cubit<UpdateAvatarState> {
  final StorageRepository _storageRepository;
  final AccountCubit _accountCubit;

  UpdateAvatarCubit({required StorageRepository storageRepository, required AccountCubit accountCubit, required AccountRepository accountRepository})
      : _storageRepository = storageRepository,
        _accountCubit = accountCubit,
        super(UpdateAvatarState.initial());

  update(Uint8List uint8List) async {
    String url = '';
    String uid = _accountCubit.state.account!.uid;
    String path = 'accounts/$uid/avatar/$uid';
    emit(UpdateAvatarState.inProgress());
    url = await _storageRepository.uploadToFirebaseStorage(uint8List: uint8List, path: path);
    await _accountCubit.updateAvatarUrl(url);
    emit(UpdateAvatarState.succeed());
  }
}
