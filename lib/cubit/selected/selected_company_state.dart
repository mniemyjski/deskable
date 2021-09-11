part of 'selected_company_cubit.dart';

enum ESelectedCompanyStatus { unknown, loading, succeed, empty }

class SelectedCompanyState extends Equatable {
  final Company? company;
  final ESelectedCompanyStatus status;

  SelectedCompanyState({this.company, required this.status});

  factory SelectedCompanyState.unknown() {
    return SelectedCompanyState(status: ESelectedCompanyStatus.unknown);
  }

  factory SelectedCompanyState.loading() {
    return SelectedCompanyState(status: ESelectedCompanyStatus.loading);
  }

  factory SelectedCompanyState.succeed({required Company company}) {
    return SelectedCompanyState(status: ESelectedCompanyStatus.succeed, company: company);
  }

  @override
  List<Object?> get props => [company, status];
}
