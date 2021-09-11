import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/account_repository.dart';
import 'package:deskable/repositories/company_repository.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:equatable/equatable.dart';
part 'selected_company_state.dart';

class SelectedCompanyCubit extends Cubit<SelectedCompanyState> {
  final CompanyCubit _companyCubit;
  final AccountRepository _accountRepository;
  final CompanyRepository _companyRepository;
  late StreamSubscription<CompanyState> _companySubscription;

  SelectedCompanyCubit(
      {required CompanyCubit companyCubit, required CompanyRepository companyRepository, required AccountRepository accountRepository})
      : _companyCubit = companyCubit,
        _companyRepository = companyRepository,
        _accountRepository = accountRepository,
        super(SelectedCompanyState.unknown()) {
    _init();
  }

  @override
  Future<void> close() {
    try {
      _companySubscription.cancel();
    } catch (e) {}
    return super.close();
  }

  void _init() {
    emit(SelectedCompanyState.loading());

    if (_companyCubit.state.status == ECompanyStatus.succeed) {
      emit(SelectedCompanyState.succeed(company: _companyCubit.state.companies!.first));
    }

    _companySubscription = _companyCubit.stream.listen((company) {
      if (company.status == ECompanyStatus.succeed) {
        emit(SelectedCompanyState.succeed(company: company.companies!.first));
      } else {
        emit(SelectedCompanyState.unknown());
      }
    });
  }

  change(Company company) {
    emit(SelectedCompanyState.loading());
    emit(SelectedCompanyState.succeed(company: company));
  }

  Future<bool> addOwner(String email) async {
    Account? account = await _accountRepository.getAccountByEmail(email);
    if (account == null) return false;

    List<String> ownerId = List.from(state.company!.ownersId);
    ownerId.add(account.uid);
    _companyRepository.update(state.company!.copyWith(ownersId: ownerId));

    return true;
  }

  Future<bool> removeOwnerByEmail(String email) async {
    Account? account = await _accountRepository.getAccountByEmail(email);
    if (account == null) return false;

    List<String> ownerId = List.from(state.company!.ownersId);
    ownerId.remove(account.uid);
    _companyRepository.update(state.company!.copyWith(ownersId: ownerId));

    return true;
  }

  Future<bool> removeOwnerById(Account account) async {
    List<String> ownerId = List.from(state.company!.ownersId);
    ownerId.remove(account.uid);
    _companyRepository.update(state.company!.copyWith(ownersId: ownerId));

    return true;
  }
}
