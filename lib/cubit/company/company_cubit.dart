import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/company_model.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository _companyRepository;
  final AccountCubit _accountCubit;
  late StreamSubscription<List<Company?>> _companiesSubscription;
  late StreamSubscription<AccountState> _accountSubscription;

  CompanyCubit({
    required CompanyRepository companyRepository,
    required AccountCubit accountCubit,
  })  : _companyRepository = companyRepository,
        _accountCubit = accountCubit,
        super(CompanyState.unknown()) {
    _init();
  }

  void _init() {
    if (_accountCubit.state.status == EAccountStatus.created) _companiesStream(_accountCubit.state);

    _accountSubscription = _accountCubit.stream.listen((event) {
      if (event.status == EAccountStatus.created) {
        _companiesStream(event);
      } else {
        try {
          _companiesSubscription.cancel();
        } catch (e) {}
        emit(CompanyState.unknown());
      }
    });
  }

  void _companiesStream(AccountState authState) {
    try {
      _companiesSubscription.cancel();
    } catch (e) {}
    _companiesSubscription = _companyRepository.stream(authState.account!.companies).listen((companies) {
      emit(state.copyWith(companies: companies, status: ECompanyStatus.succeed));
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
      String id = await _companyRepository.create(company.copyWith(owners: [_accountCubit.state.account!.uid]));
      _accountCubit.addCompanies(idAccount: _accountCubit.state.account!.uid, idCompany: id);
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
