import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_account_state.dart';

class SearchAccountCubit extends Cubit<SearchAccountState> {
  SearchAccountCubit() : super(SearchAccountState.init());

  searchByEmail() {}
}
