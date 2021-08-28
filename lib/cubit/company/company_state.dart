part of 'company_cubit.dart';

enum ECompanyStatus { unknown, loading, succeed }

class CompanyState extends Equatable {
  final List<Company>? companies;
  final ECompanyStatus eCompanyStatus;

  const CompanyState({this.companies, required this.eCompanyStatus});

  factory CompanyState.unknown() {
    return CompanyState(eCompanyStatus: ECompanyStatus.unknown);
  }

  factory CompanyState.loading() {
    return CompanyState(eCompanyStatus: ECompanyStatus.loading);
  }

  factory CompanyState.succeed(List<Company> companies) {
    return CompanyState(eCompanyStatus: ECompanyStatus.succeed, companies: companies);
  }

  @override
  List<Object?> get props => [companies, eCompanyStatus];
}
