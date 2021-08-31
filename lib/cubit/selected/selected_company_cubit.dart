import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
part 'selected_company_state.dart';

class SelectedCompanyCubit extends Cubit<SelectedCompanyState> {
  final CompanyCubit _companyCubit;

  late StreamSubscription<CompanyState> _companySubscription;

  SelectedCompanyCubit({required CompanyCubit companyCubit})
      : _companyCubit = companyCubit,
        super(SelectedCompanyState.unknown()) {
    try {
      _companySubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }
    _companySubscription = _companyCubit.stream.listen((company) {
      if (company.status == ECompanyStatus.succeed) {
        emit(SelectedCompanyState.succeed(company: company.companies!.first));
      } else {
        emit(SelectedCompanyState.unknown());
      }
    });
  }

  @override
  Future<void> close() {
    try {
      _companySubscription.cancel();
    } catch (e) {
      Failure(message: "Not Initialization");
    }
    return super.close();
  }
}
