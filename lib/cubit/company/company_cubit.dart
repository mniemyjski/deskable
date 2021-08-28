import 'package:bloc/bloc.dart';
import 'package:deskable/models/company_model.dart';
import 'package:equatable/equatable.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit() : super(CompanyState.unknown());
}
