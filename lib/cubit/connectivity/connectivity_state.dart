part of 'connectivity_cubit.dart';

enum EConnectivityStatus {
  unknown,
  connected,
  disconnected,
}

class ConnectivityState extends Equatable {
  final EConnectivityStatus eConnectivityStatus;

  ConnectivityState(this.eConnectivityStatus);

  factory ConnectivityState.unknown() {
    return ConnectivityState(EConnectivityStatus.unknown);
  }

  factory ConnectivityState.connected() {
    return ConnectivityState(EConnectivityStatus.connected);
  }

  factory ConnectivityState.disconnected() {
    return ConnectivityState(EConnectivityStatus.disconnected);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [eConnectivityStatus];
}
