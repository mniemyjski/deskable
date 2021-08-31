part of 'company_cubit.dart';

enum ECompanyStatus { unknown, loading, succeed }

class CompanyState extends Equatable {
  final List<Company>? companies;
  final Account? account;
  final ECompanyStatus status;

  const CompanyState({required this.companies, required this.status, this.account});

  factory CompanyState.unknown() {
    return CompanyState(status: ECompanyStatus.unknown, companies: []);
  }

  @override
  List<Object?> get props => [companies, status, account];

  CompanyState copyWith({
    List<Company>? companies,
    Account? account,
    ECompanyStatus? status,
  }) {
    return CompanyState(
      companies: companies ?? this.companies,
      account: account ?? this.account,
      status: status ?? this.status,
    );
  }
}
