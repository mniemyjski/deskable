import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:equatable/equatable.dart';

part '../company/company_employees_state.dart';

class CompanyEmployeesCubit extends Cubit<CompanyEmployeesState> {
  final SelectedCompanyCubit _selectedCompanyCubit;
  final AccountRepository _accountRepository;
  late StreamSubscription<SelectedCompanyState> _selectedCompanySub;
  late StreamSubscription<List<Account>?> _employeesSub;

  CompanyEmployeesCubit({required SelectedCompanyCubit selectedCompanyCubit, required AccountRepository accountRepository})
      : _selectedCompanyCubit = selectedCompanyCubit,
        _accountRepository = accountRepository,
        super(CompanyEmployeesState.unknown()) {
    init();
  }

  void init() {
    if (_selectedCompanyCubit.state.status == ESelectedCompanyStatus.succeed) {
      _sub(_selectedCompanyCubit.state.company!.id!);
    }

    _selectedCompanySub = _selectedCompanyCubit.stream.listen((event) {
      if (event.status == ESelectedCompanyStatus.succeed) {
        _sub(event.company!.id!);
      } else {
        try {
          _employeesSub.cancel();
        } catch (e) {}
        emit(CompanyEmployeesState.unknown());
      }
    });
  }

  _sub(String companyId) {
    emit(CompanyEmployeesState.loading());
    _employeesSub = _accountRepository.streamCompanyAccounts(companyId).listen((event) {
      if (event != null) emit(CompanyEmployeesState.succeed(accounts: event));
    });
  }

  // addEmployee(Account account) {
  //   List<String> c = List.from(account.companies);
  //   if (!c.contains(_selectedCompanyCubit.state.company!.id!)) {
  //     c.add(_selectedCompanyCubit.state.company!.id!);
  //
  //     _accountRepository.updateAccount(account.copyWith(companies: c));
  //   }
  // }
  //
  // removeEmployee(Account account) {
  //   List<String> c = account.companies;
  //   c.remove(_selectedCompanyCubit.state.company!.id!);
  //
  //   _accountRepository.updateAccount(account.copyWith(companies: c));
  // }

  Future<bool> addToCompanyById(String accountId) async {
    Account? account = await _accountRepository.getAccountById(accountId);
    if (account != null) {
      List<String> c = List.from(account.companies);
      c.add(_selectedCompanyCubit.state.company!.id!);

      await _accountRepository.updateAccount(account.copyWith(companies: c));
      return true;
    }
    return false;
  }

  Future<bool> addToCompanyByEmail(String email) async {
    Account? account = await _accountRepository.getAccountByEmail(email);
    if (account != null) {
      List<String> c = List.from(account.companies);
      c.add(_selectedCompanyCubit.state.company!.id!);

      await _accountRepository.updateAccount(account.copyWith(companies: c));
      return true;
    }
    return false;
  }

  Future<bool> removeFromCompanyByEmail(String email) async {
    Account? account = await _accountRepository.getAccountByEmail(email);
    if (account != null) {
      List<String> c = List.from(account.companies);
      c.remove(_selectedCompanyCubit.state.company!.id!);

      _accountRepository.updateAccount(account.copyWith(companies: c));
      return true;
    }
    return false;
  }

  Future<bool> removeFromCompanyById(String accountId) async {
    Account? account = await _accountRepository.getAccountById(accountId);
    if (account != null) {
      List<String> c = List.from(account.companies);
      c.remove(_selectedCompanyCubit.state.company!.id!);

      _accountRepository.updateAccount(account.copyWith(companies: c));
      return true;
    }
    return false;
  }

  @override
  Future<void> close() {
    try {
      _selectedCompanySub.cancel();
    } catch (e) {}
    try {
      _employeesSub.cancel();
    } catch (e) {}
    return super.close();
  }
}
