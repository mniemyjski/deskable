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
  final AccountCubit _accountCubit;
  final AccountRepository _accountRepository;
  final CompanyRepository _companyRepository;
  late StreamSubscription<CompanyState> _companySubscription;

  SelectedCompanyCubit(
      {required CompanyCubit companyCubit,
      required CompanyRepository companyRepository,
      required AccountRepository accountRepository,
      required AccountCubit accountCubit})
      : _companyCubit = companyCubit,
        _accountCubit = accountCubit,
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

  Future<bool> addOwnerByEmail(String email) async {
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
    if (_accountCubit.state.account!.uid == account.uid) return false;

    List<String> ownerId = List.from(state.company!.ownersId);
    ownerId.remove(account.uid);
    _companyRepository.update(state.company!.copyWith(ownersId: ownerId));

    return true;
  }

  Future<bool> removeOwnerById(String accountId) async {
    if (_accountCubit.state.account!.uid == accountId) return false;
    List<String> ownerId = List.from(state.company!.ownersId);
    ownerId.remove(accountId);
    _companyRepository.update(state.company!.copyWith(ownersId: ownerId));

    return true;
  }

  Future<bool> addEmployeeByEmail(String email) async {
    Account? account = await _accountRepository.getAccountByEmail(email);
    if (account == null) return false;

    List<String> employeesId = List.from(state.company!.employeesId);
    employeesId.add(account.uid);
    _companyRepository.update(state.company!.copyWith(employeesId: employeesId));

    return true;
  }

  Future<bool> removeEmployeeByEmail(String email) async {
    Account? account = await _accountRepository.getAccountByEmail(email);
    if (account == null) return false;

    List<String> employeesId = List.from(state.company!.employeesId);
    employeesId.remove(account.uid);
    _companyRepository.update(state.company!.copyWith(employeesId: employeesId));

    return true;
  }

  Future<bool> removeEmployeeById(String accountId) async {
    List<String> employeesId = List.from(state.company!.employeesId);
    employeesId.remove(accountId);
    _companyRepository.update(state.company!.copyWith(employeesId: employeesId));

    return true;
  }
}
