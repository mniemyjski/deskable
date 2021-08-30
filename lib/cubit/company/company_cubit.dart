import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/company_model.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
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
    if (_accountCubit.state.status == EAccountStatus.created) {
      _companiesSubscription = _companyRepository.stream(_accountCubit.state.account!.companies).listen((companies) {
        emit(CompanyState.succeed(companies));
      });
    } else {
      try {
        _companiesSubscription.cancel();
      } catch (e) {
        Failure(message: "Not Initialization");
      }
      emit(CompanyState.unknown());
    }
  }

  @override
  Future<void> close() {
    _companiesSubscription.cancel();
    _accountSubscription.cancel();
    return super.close();
  }

  Future<void> create(Company company) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      return await _companyRepository.create(company.copyWith(owner: _accountCubit.state.account!.uid));
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
