import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/company_model.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'company_state.dart';

class CompanyCubit extends HydratedCubit<CompanyState> {
  final CompanyRepository _companyRepository;
  final AccountRepository _accountRepository;
  final AccountCubit _accountCubit;
  final bool _owner;

  final List<Account> _accounts = [];

  late StreamSubscription<List<Company?>> _companiesSubscription;
  late StreamSubscription<AccountState> _accountSubscription;

  CompanyCubit(
      {required CompanyRepository companyRepository,
      required AccountCubit accountCubit,
      required AccountRepository accountRepository,
      bool owner = false})
      : _companyRepository = companyRepository,
        _accountCubit = accountCubit,
        _accountRepository = accountRepository,
        _owner = owner,
        super(CompanyState.unknown()) {
    _init();
  }

  void _init() {
    if (_accountCubit.state.status == EAccountStatus.created) _sub(_accountCubit.state);

    try {
      _accountSubscription.cancel();
    } catch (e) {}
    _accountSubscription = _accountCubit.stream.listen((event) {
      if (event.status == EAccountStatus.created) {
        _sub(event);
      } else {
        try {
          _companiesSubscription.cancel();
        } catch (e) {}
        if (state.status != ECompanyStatus.unknown) emit(CompanyState.unknown());
      }
    });
  }

  void _sub(AccountState authState) {
    try {
      _companiesSubscription.cancel();
    } catch (e) {}
    _companiesSubscription = _companyRepository.stream(accountId: _accountCubit.state.account!.uid, owner: _owner).listen((companies) async {
      if (companies.isNotEmpty) {
        if (state.status == ECompanyStatus.succeed) {
          if (_change(companies)) {
            List<Company> _companies = await _buildCompanies(companies);
            emit(state.copyWith(companies: _companies, status: ECompanyStatus.succeed));
          }
        } else {
          List<Company> _companies = await _buildCompanies(companies);
          emit(state.copyWith(companies: _companies, status: ECompanyStatus.succeed));
        }
      } else {
        if (state.status != ECompanyStatus.empty) emit(state.copyWith(companies: [], status: ECompanyStatus.empty));
      }
    });
  }

  bool _change(List<Company> companies) {
    bool _change = false;
    for (var company in companies) {
      if (!state.companies!.contains(company)) _change = true;
    }
    for (var company in state.companies!) {
      if (!companies.contains(company)) _change = true;
    }
    return _change;
  }

  Future<List<Company>> _buildCompanies(List<Company> companies) async {
    List<Company> _companies = [];

    for (var company in companies) {
      List<Account> _owners = [];
      List<Account> _employees = [];

      for (var ownerId in company.ownersId) {
        if (_accounts.contains(ownerId)) {
          Account account = _accounts.firstWhere((e) => e.uid == ownerId);
          _owners.add(account);
        } else {
          if (_accountCubit.state.status == EAccountStatus.created) {
            Account? account = await _accountRepository.getAccountById(ownerId);
            if (account != null) {
              _accounts.add(account);
              _owners.add(account);
            }
          }
        }
      }

      for (var employeeId in company.employeesId) {
        if (_accounts.contains(employeeId)) {
          Account account = _accounts.firstWhere((e) => e.uid == employeeId);
          _employees.add(account);
        } else {
          if (_accountCubit.state.status == EAccountStatus.created) {
            Account? account = await _accountRepository.getAccountById(employeeId);
            if (account != null) {
              _accounts.add(account);
              _employees.add(account);
            }
          }
        }
      }

      _owners.sort((a, b) => a.name.compareTo(b.name));
      _employees.sort((a, b) => a.name.compareTo(b.name));

      _companies.add(company.copyWith(owners: _owners, employees: _employees));
      _companies.sort((a, b) => a.name.compareTo(b.name));
    }
    return _companies;
  }

  @override
  Future<void> close() {
    try {
      _companiesSubscription.cancel();
    } catch (e) {}
    try {
      _accountSubscription.cancel();
    } catch (e) {}

    return super.close();
  }

  Future<void> create(Company company) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      await _companyRepository.create(company.copyWith(
        ownersId: [_accountCubit.state.account!.uid],
        employeesId: [_accountCubit.state.account!.uid],
      ));
    }
  }

  Future<void> update(Company company) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      return await _companyRepository.update(company);
    }
  }

  Future<void> delete(Company company) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      return await _companyRepository.delete(company);
    }
  }

  @override
  CompanyState? fromJson(Map<String, dynamic> json) {
    return CompanyState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(CompanyState state) {
    return state.toMap(hydrated: true);
  }
}
