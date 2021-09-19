part of 'search_account_cubit.dart';

enum ESearchAccount { init, loading, succeed, empty }

class SearchAccountState extends Equatable {
  final List<Account> accounts;
  final ESearchAccount status;

  SearchAccountState({required this.accounts, required this.status});

  factory SearchAccountState.init() {
    return SearchAccountState(accounts: [], status: ESearchAccount.init);
  }

  factory SearchAccountState.loading() {
    return SearchAccountState(accounts: [], status: ESearchAccount.loading);
  }

  factory SearchAccountState.empty() {
    return SearchAccountState(accounts: [], status: ESearchAccount.empty);
  }

  factory SearchAccountState.succeed(List<Account> accounts) {
    return SearchAccountState(accounts: accounts, status: ESearchAccount.succeed);
  }

  @override
  List<Object> get props => [accounts, status];
}
