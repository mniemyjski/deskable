import 'dart:async';

import 'package:deskable/bloc/bloc.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _accountRepository;
  final AuthBloc _authBloc;
  late StreamSubscription<Account?> _accountSubscription;
  late StreamSubscription<AuthState> _authSubscription;

  AccountCubit({
    required AccountRepository accountRepository,
    required AuthBloc authBloc,
  })  : _accountRepository = accountRepository,
        _authBloc = authBloc,
        super(AccountState.unknown()) {
    Logger().e('account start');
    _authSubscription = _authBloc.stream.listen((event) {
      Logger().e('account ${event.status}');
      if (event.status == EAuthStatus.authenticated) {
        _accountSubscription = _accountRepository.streamMyAccount(event.user!.uid).listen((account) {
          account != null ? emit(AccountState.created(account)) : emit(AccountState.unCreated());
        });
      } else {
        try {
          _accountSubscription.cancel();
        } catch (e) {
          Failure(message: "Not Initialization");
        }
        emit(AccountState.unknown());
      }
    });
  }

  Future<bool> updateName(String name) async {
    bool available = await _accountRepository.nameAvailable(name);

    if (available) {
      _accountRepository.updateAccount(state.account!.copyWith(name: name));
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateAvatarUrl(String url) async {
    await _accountRepository.updateAccount(state.account!.copyWith(photoUrl: url));
  }

  Future<bool> createAccount(String name) async {
    String uid = _authBloc.state.user!.uid;
    String url = _authBloc.state.user!.photoURL ?? '';
    bool available = await _accountRepository.nameAvailable(name);
    if (available) {
      _accountRepository.createAccount(Account(uid: uid, name: name, photoUrl: url));
      return true;
    } else {
      return false;
    }
  }

  Future<Account?> getAccount(String id) async {
    return await _accountRepository.getAccount(id);
  }

  @override
  Future<void> close() {
    _accountSubscription.cancel();
    _authSubscription.cancel();
    return super.close();
  }
}
