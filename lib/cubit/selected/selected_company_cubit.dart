import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/company_repository.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
part 'selected_company_state.dart';

class SelectedCompanyCubit extends Cubit<SelectedCompanyState> {
  final CompanyCubit _companyCubit;
  final CompanyRepository _companyRepository;
  late StreamSubscription<CompanyState> _companySubscription;

  SelectedCompanyCubit({required CompanyCubit companyCubit, required CompanyRepository companyRepository})
      : _companyCubit = companyCubit,
        _companyRepository = companyRepository,
        super(SelectedCompanyState.unknown()) {
    _init();
  }

  void _init() {
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
    emit(SelectedCompanyState.unknown());
    emit(SelectedCompanyState.succeed(company: company));
  }

  @override
  Future<void> close() {
    try {
      _companySubscription.cancel();
    } catch (e) {}
    return super.close();
  }
}
