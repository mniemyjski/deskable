part of 'company_cubit.dart';

enum ECompanyStatus { unknown, loading, succeed }

class CompanyState extends Equatable {
  final List<Company?> companies;
  final ECompanyStatus status;

  const CompanyState({required this.companies, required this.status});

  factory CompanyState.unknown() {
    return CompanyState(status: ECompanyStatus.unknown, companies: []);
  }

  factory CompanyState.loading() {
    return CompanyState(status: ECompanyStatus.loading, companies: []);
  }

  factory CompanyState.succeed(List<Company?> companies) {
    return CompanyState(status: ECompanyStatus.succeed, companies: companies);
  }

  @override
  List<Object?> get props => [companies, status];
}
