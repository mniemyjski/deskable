import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityCubit(this.connectivity) : super(ConnectivityState.unknown()) {
    _connectivitySubscription = connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile || event == ConnectivityResult.wifi || event == ConnectivityResult.ethernet) {
        emit(ConnectivityState.connected());
      } else {
        emit(ConnectivityState.disconnected());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
