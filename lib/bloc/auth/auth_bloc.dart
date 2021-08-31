import 'dart:async';

import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<User?> _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthState.unknown()) {
    try {
      _userSubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }
    _userSubscription = _authRepository.user.listen((user) => add(AuthUserChanged(user: user)));
  }

  @override
  Future<void> close() {
    try {
      _userSubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }
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
    yield event.user != null ? AuthState.authenticated(user: event.user!) : AuthState.unauthenticated();
  }
}
