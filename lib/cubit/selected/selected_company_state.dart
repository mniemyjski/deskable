part of 'selected_company_cubit.dart';

class SelectedCompanyState extends Equatable {
  final Company? company;
  final EStatus status;

  SelectedCompanyState({this.company, required this.status});

  factory SelectedCompanyState.unknown() {
    return SelectedCompanyState(status: EStatus.unknown);
  }

  factory SelectedCompanyState.loading() {
    return SelectedCompanyState(status: EStatus.loading);
  }

  factory SelectedCompanyState.succeed({required Company company}) {
    return SelectedCompanyState(status: EStatus.succeed, company: company);
  }

  @override
  List<Object?> get props => [company, status];
}
