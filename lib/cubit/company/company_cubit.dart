import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/company_model.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:deskable/utilities/utilities.dart';
part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository _companyRepository;
  final AccountRepository _accountRepository;
  final AccountCubit _accountCubit;
  final bool _owner;
  late StreamSubscription<List<Company?>> _companiesSubscription;
  late StreamSubscription<AccountState> _accountSubscription;
  List<Account> accounts = [];

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

    _accountSubscription = _accountCubit.stream.listen((event) {
      if (event.status == EAccountStatus.created) {
        _sub(event);
      } else {
        try {
          _companiesSubscription.cancel();
        } catch (e) {}
        emit(CompanyState.unknown());
      }
    });
  }

  void _sub(AccountState authState) {
    try {
      _companiesSubscription.cancel();
    } catch (e) {}
    _companiesSubscription = _companyRepository
        .stream(companies: authState.account!.companies, accountId: _accountCubit.state.account!.uid, owner: _owner)
        .listen((companies) async {
      if (companies.isNotEmpty) {
        List<Company> _companies = [];

        for (var company in companies) {
          List<Account> owners = [];

          for (var ownerId in company.ownersId) {
            if (accounts.contains(ownerId)) {
              Account account = accounts.firstWhere((e) => e.uid == ownerId);
              owners.add(account);
            } else {
              if (_accountCubit.state.status == EAccountStatus.created) {
                Account? account = await _accountRepository.getAccountById(ownerId);
                if (account != null) {
                  accounts.add(account);
                  owners.add(account);
                }
              }
            }
          }
          _companies.add(company.copyWith(owners: owners));
        }

        emit(state.copyWith(companies: _companies, status: ECompanyStatus.succeed));
      } else {
        emit(state.copyWith(companies: companies, status: ECompanyStatus.empty));
      }
    });
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
      String id = await _companyRepository.create(company.copyWith(ownersId: [_accountCubit.state.account!.uid]));
      List<String> c = List.from(_accountCubit.state.account!.companies);
      c.add(id);
      _accountCubit.updateCompanies(c);
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
}
