import 'dart:async';

import 'package:deskable/bloc/bloc.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'preference_state.dart';

class PreferenceCubit extends Cubit<PreferenceState> {
  final PreferenceRepository _preferenceRepository;
  final AuthBloc _authBloc;
  late StreamSubscription<Preference?> _preferenceSubscription;
  late StreamSubscription<AuthState> _authSubscription;

  PreferenceCubit({
    required AuthBloc authBloc,
    required PreferenceRepository preferenceRepository,
  })  : _authBloc = authBloc,
        _preferenceRepository = preferenceRepository,
        super(PreferenceState.unknown()) {
    if (_authBloc.state.status == EAuthStatus.authenticated) {
      _preferenceSubscription = _preferenceRepository.streamPreference(_authBloc.state.user!.uid).listen((preference) {
        preference != null ? emit(PreferenceState.created(preference)) : emit(PreferenceState.unCreated());
      });
    } else {
      try {
        _preferenceSubscription.cancel();
      } catch (e) {
        Failure(message: "Not Initialization");
      }
      emit(PreferenceState.unknown());
    }
  }

  createPreference() async {
    String uid = _authBloc.state.user!.uid;
    _preferenceRepository.createPreference(Preference(uid: uid));
  }

  @override
  Future<void> close() {
    _preferenceSubscription.cancel();
    _authSubscription.cancel();
    return super.close();
  }
}
