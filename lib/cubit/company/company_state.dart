part of 'company_cubit.dart';

enum ECompanyStatus { unknown, loading, succeed, empty }

class CompanyState extends Equatable {
  final List<Company>? companies;

  final ECompanyStatus status;

  const CompanyState({required this.companies, required this.status});

  factory CompanyState.unknown() {
    return CompanyState(status: ECompanyStatus.unknown, companies: []);
  }

  @override
  List<Object?> get props => [companies, status];

  CompanyState copyWith({
    List<Company>? companies,
    ECompanyStatus? status,
  }) {
    return CompanyState(
      companies: companies ?? this.companies,
      status: status ?? this.status,
    );
  }
}
