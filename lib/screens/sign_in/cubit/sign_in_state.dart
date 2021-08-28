part of 'sign_in_cubit.dart';

enum SignInStatus { initial, loading, success }
enum SignInFormType { initial, signIn, register, reset }

class SignInState extends Equatable {
  final String email;
  final String password;
  final SignInStatus signInStatus;
  final Failure failure;
  final SignInFormType signInFormType;

  const SignInState({
    required this.email,
    required this.password,
    required this.signInStatus,
    required this.failure,
    required this.signInFormType,
  });

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [email, password, signInStatus, signInFormType, failure];

  factory SignInState.initial() {
    return SignInState(
      email: '',
      password: '',
      signInStatus: SignInStatus.initial,
      signInFormType: SignInFormType.initial,
      failure: const Failure(),
    );
  }

  SignInState copyWith({
    String? email,
    String? password,
    SignInStatus? signInStatus,
    Failure? failure,
    SignInFormType? signInFormType,
  }) {
    if ((email == null || identical(email, this.email)) &&
        (password == null || identical(password, this.password)) &&
        (signInStatus == null || identical(signInStatus, this.signInStatus)) &&
        (failure == null || identical(failure, this.failure)) &&
        (signInFormType == null || identical(signInFormType, this.signInFormType))) {
      return this;
    }

    return new SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      signInStatus: signInStatus ?? this.signInStatus,
      failure: failure ?? this.failure,
      signInFormType: signInFormType ?? this.signInFormType,
    );
  }
}
