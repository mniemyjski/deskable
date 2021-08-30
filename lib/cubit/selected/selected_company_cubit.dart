import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/enums.dart';
import 'package:equatable/equatable.dart';

part 'selected_company_state.dart';

class SelectedCompanyCubit extends Cubit<SelectedCompanyState> {
  final CompanyCubit _companyCubit;

  SelectedCompanyCubit({required CompanyCubit companyCubit})
      : _companyCubit = companyCubit,
        super(SelectedCompanyState.unknown()) {
    _companyCubit.stream.listen((company) {
      if (company.status == ECompanyStatus.succeed) {
        emit(SelectedCompanyState.succeed(company: company.companies.first!));
      }
    });
  }
}
