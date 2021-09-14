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

  Map<String, dynamic> toMap({bool hydrated = false}) {
    List<Map<String, dynamic>> _companies = [];
    this.companies!.forEach((company) {
      _companies.add(company.toMap(hydrated: hydrated));
    });

    return {
      'companies': _companies,
      'status': Enums.toText(this.status),
    };
  }

  factory CompanyState.fromMap(Map<String, dynamic> map, {bool hydrated = false}) {
    List<Company> _companies = [];
    map['companies'].forEach((company) {
      _companies.add(Company.fromMap(company));
    });

    return CompanyState(
      companies: _companies,
      status: Enums.toEnum(map['status'] ?? 'unknown', ECompanyStatus.values),
    );
  }
}
