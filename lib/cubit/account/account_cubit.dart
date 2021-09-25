import 'dart:async';

import 'package:deskable/bloc/bloc.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

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
    _init();
  }

  void _init() {
    if (_authBloc.state.status == EAuthStatus.authenticated) _sub(_authBloc.state);

    try {
      _authSubscription.cancel();
    } catch (e) {}
    _authSubscription = _authBloc.stream.listen((event) {
      if (event.status == EAuthStatus.authenticated) {
        _sub(event);
      } else {
        try {
          _accountSubscription.cancel();
        } catch (e) {}
        if (state.status != EAccountStatus.unknown) emit(AccountState.unknown());
      }
    });
  }

  void _sub(AuthState authState) {
    try {
      _accountSubscription.cancel();
    } catch (e) {}
    _accountSubscription = _accountRepository.streamMyAccount(authState.uid!).listen((account) {
      if (account != null) {
        if (state.account != account || state.status != EAccountStatus.created) emit(AccountState.created(account));
      } else if (state.status != EAccountStatus.uncreated) {
        emit(AccountState.unCreated());
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
    String uid = _authBloc.state.uid!;
    String url = _authBloc.state.photoURL ?? '';
    String email = _authBloc.state.email ?? '';
    bool available = await _accountRepository.nameAvailable(name);
    if (available) {
      _accountRepository.createAccount(Account(uid: uid, name: name, photoUrl: url, email: email));
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> close() async {
    try {
      _authSubscription.cancel();
    } catch (e) {}
    try {
      _accountSubscription.cancel();
    } catch (e) {}
    return super.close();
  }

  // @override
  // AccountState? fromJson(Map<String, dynamic> json) {
  //   return AccountState.fromMap(json);
  // }
  //
  // @override
  // Map<String, dynamic>? toJson(AccountState state) {
  //   return state.toMap();
  // }
}
