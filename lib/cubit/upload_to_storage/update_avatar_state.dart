part of 'update_avatar_cubit.dart';

enum EUpdateAvatarStateStatus { initial, inProgress, succeed, failure }

class UpdateAvatarState extends Equatable {
  final EUpdateAvatarStateStatus eUpdateAvatarStateStatus;

  UpdateAvatarState(this.eUpdateAvatarStateStatus);

  factory UpdateAvatarState.initial() {
    return UpdateAvatarState(EUpdateAvatarStateStatus.initial);
  }

  factory UpdateAvatarState.inProgress() {
    return UpdateAvatarState(EUpdateAvatarStateStatus.inProgress);
  }

  factory UpdateAvatarState.succeed() {
    return UpdateAvatarState(EUpdateAvatarStateStatus.succeed);
  }

  factory UpdateAvatarState.failure() {
    return UpdateAvatarState(EUpdateAvatarStateStatus.failure);
  }

  @override
  List<Object?> get props => [eUpdateAvatarStateStatus];
}
