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
    _init();
  }

  void _init() {
    if (_authBloc.state.status == EAuthStatus.authenticated) _accountSub(_authBloc.state);

    _authSubscription = _authBloc.stream.listen((event) {
      if (event.status == EAuthStatus.authenticated) {
        _accountSub(event);
      } else {
        try {
          _accountSubscription.cancel();
        } catch (e) {}
        emit(AccountState.unknown());
      }
    });
  }

  void _accountSub(AuthState authState) {
    _accountSubscription = _accountRepository.streamMyAccount(authState.user!.uid).listen((account) {
      account != null ? emit(AccountState.created(account)) : emit(AccountState.unCreated());
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
    String email = _authBloc.state.user!.email ?? '';
    bool available = await _accountRepository.nameAvailable(name);
    if (available) {
      _accountRepository.createAccount(Account(uid: uid, name: name, photoUrl: url, companies: ['a0oIGtXYDHGV2wyE7p1r'], email: email));
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateCompanies(List<String> companies) async {
    await _accountRepository.updateAccount(state.account!.copyWith(companies: companies));
  }

  @override
  Future<void> close() {
    try {
      _authSubscription.cancel();
    } catch (e) {}
    try {
      _accountSubscription.cancel();
    } catch (e) {}
    return super.close();
  }
}
