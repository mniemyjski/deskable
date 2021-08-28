part of 'preference_cubit.dart';

enum EPreferenceStatus { unknown, created, unCreated }

class PreferenceState extends Equatable {
  final Preference? preference;
  final EPreferenceStatus status;
  const PreferenceState({this.preference, required this.status});

  factory PreferenceState.unknown() {
    return PreferenceState(status: EPreferenceStatus.unknown);
  }

  factory PreferenceState.unCreated() {
    return PreferenceState(status: EPreferenceStatus.unCreated);
  }

  factory PreferenceState.created(Preference preference) {
    return PreferenceState(preference: preference, status: EPreferenceStatus.created);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [preference, status];
}
