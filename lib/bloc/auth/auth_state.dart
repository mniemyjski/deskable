part of 'auth_bloc.dart';

enum EAuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final String? uid;
  final String? email;
  final String? photoURL;
  final EAuthStatus status;

  const AuthState({
    this.uid,
    this.email,
    this.photoURL,
    this.status = EAuthStatus.unknown,
  });

  factory AuthState.unknown() => const AuthState();

  factory AuthState.authenticated({required User user}) {
    return AuthState(uid: user.uid, email: user.email, photoURL: user.photoURL, status: EAuthStatus.authenticated);
  }

  factory AuthState.unauthenticated() => const AuthState(status: EAuthStatus.unauthenticated);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [uid, email, photoURL, status];

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'email': this.email,
      'photoURL': this.photoURL,
      'status': Enums.toText(this.status),
    };
  }

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      uid: map['uid'],
      email: map['email'],
      photoURL: map['photoURL'],
      status: Enums.toEnum(map['status'] ?? 'unknown', EAuthStatus.values) as EAuthStatus,
    );
  }
}
