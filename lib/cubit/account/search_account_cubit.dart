import 'package:bloc/bloc.dart';
import 'package:deskable/models/account.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'search_account_state.dart';

class SearchAccountCubit extends Cubit<SearchAccountState> {
  final AccountRepository _accountRepository;

  SearchAccountCubit({required AccountRepository accountRepository})
      : _accountRepository = accountRepository,
        super(SearchAccountState.init());

  search(String search) async {
    emit(SearchAccountState.loading());
    List<Account> accounts = await _accountRepository.searchAccount(search);
    accounts.isNotEmpty ? emit(SearchAccountState.succeed(accounts)) : emit(SearchAccountState.empty());
  }
}
