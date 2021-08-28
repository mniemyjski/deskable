part of 'account_cubit.dart';

enum EAccountStatus { unknown, uncreated, created }

class AccountState extends Equatable {
  final Account? account;
  final EAccountStatus status;

  AccountState({this.account, this.status = EAccountStatus.unknown});

  factory AccountState.unknown() {
    return AccountState(status: EAccountStatus.unknown);
  }

  factory AccountState.unCreated() {
    return AccountState(status: EAccountStatus.uncreated);
  }

  factory AccountState.created(Account account) {
    return AccountState(account: account, status: EAccountStatus.created);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [account, status];
}

// abstract class AccountState extends Equatable {
//   const AccountState();
// }
//
// class AccountInitial extends AccountState {
//   @override
//   List<Object> get props => [];
// }
//
// class AccountUnCreate extends AccountState {
//   @override
//   List<Object> get props => [];
// }
//
// class AccountLoadSuccess extends AccountState {
//   final Account account;
//
//   AccountLoadSuccess(this.account);
//
//   @override
//   List<Object> get props => [account];
// }
//
// class AccountLoadFailure extends AccountState {
//   @override
//   List<Object> get props => [];
// }
