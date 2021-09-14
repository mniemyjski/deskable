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

  Map<String, dynamic> toMap() {
    return {
      'account': this.account?.toMap() ?? null,
      'status': Enums.toText(this.status),
    };
  }

  factory AccountState.fromMap(Map<String, dynamic> map) {
    return AccountState(
      account: map['account'] != null ? Account.fromMap(map['account']) : null,
      status: Enums.toEnum(map['status'] ?? 'unknown', EAccountStatus.values),
    );
  }
}
