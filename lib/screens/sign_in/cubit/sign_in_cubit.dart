import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository;

  SignInCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignInState.initial());

  signInWithGoogle() async {
    emit(state.copyWith(signInStatus: SignInStatus.loading));
    try {
      await _authRepository.signInWithGoogle();
      await emitSignInStatusSucceed();
    } on Failure catch (e) {
      emit(SignInState.initial());
      return e;
    }
  }

  void changeForm(SignInFormType signInFormType) async {
    emit(state.copyWith(signInFormType: signInFormType));
    emit(state.copyWith(email: '', password: ''));
  }

  void valueForm({String? email, String? password}) {
    emit(state.copyWith(email: email, password: password));
  }

  signInWithEmail() async {
    try {
      emit(state.copyWith(signInStatus: SignInStatus.loading));
      if (state.signInFormType == SignInFormType.signIn) {
        await _authRepository.signInWithEmailAndPassword(state.email, state.password);
        await emitSignInStatusSucceed();
      } else if (state.signInFormType == SignInFormType.register) {
        await _authRepository.createUserWithEmailAndPassword(state.email, state.password);
        await emitSignInStatusSucceed();
      } else if (state.signInFormType == SignInFormType.reset) {
        await _authRepository.resetPassword(state.email);
        emit(SignInState.initial());
      }
    } on Failure catch (e) {
      emit(SignInState.initial());
      return e;
    }
  }

  String buttonName() {
    if (state.signInFormType == SignInFormType.signIn) return Languages.sign_in();
    if (state.signInFormType == SignInFormType.register) return Languages.create_account();
    return Languages.send();
  }

  String titleName() {
    if (state.signInFormType == SignInFormType.signIn) return Languages.login();
    if (state.signInFormType == SignInFormType.register) return Languages.register();
    return Languages.reset_password();
  }

  emitSignInStatusSucceed() async {
    await Future.delayed(Duration(seconds: 5));
    emit(state.copyWith(signInStatus: SignInStatus.success));
  }
}
