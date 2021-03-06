import 'dart:async';

import 'package:deskable/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:deskable/utilities/utilities.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<User?> _authSubscription;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthState.unknown()) {
    _init();
  }

  void _init() {
    try {
      _authSubscription.cancel();
    } catch (e) {}

    _authSubscription = _authRepository.user.listen((user) {
      add(AuthUserChanged(user: user));
    });
  }

  @override
  Future<void> close() async {
    try {
      _authSubscription.cancel();
    } catch (e) {}
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthUserChanged) {
      yield* _mapAuthUserChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      await _authRepository.signOut();
    } else if (event is AuthDeleteRequested) {
      await _authRepository.delete();
    }
  }

  Stream<AuthState> _mapAuthUserChangedToState(AuthUserChanged event) async* {
    if (event.user != null) {
      if (state.status != EAuthStatus.authenticated || event.user!.uid != state.uid) yield AuthState.authenticated(user: event.user!);
    } else {
      if (state.status != EAuthStatus.unauthenticated) yield AuthState.unauthenticated();
    }
  }

  // @override
  // AuthState? fromJson(Map<String, dynamic> json) {
  //   return AuthState.fromMap(json);
  // }
  //
  // @override
  // Map<String, dynamic>? toJson(AuthState state) {
  //   return state.toMap();
  // }
}
