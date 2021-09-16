part of 'organization_cubit.dart';

enum ECompanyStatus { unknown, loading, succeed, empty }

class OrganizationState extends Equatable {
  final List<Organization>? companies;

  final ECompanyStatus status;

  const OrganizationState({required this.companies, required this.status});

  factory OrganizationState.unknown() {
    return OrganizationState(status: ECompanyStatus.unknown, companies: []);
  }

  @override
  List<Object?> get props => [companies, status];

  OrganizationState copyWith({
    List<Organization>? companies,
    ECompanyStatus? status,
  }) {
    return OrganizationState(
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

  factory OrganizationState.fromMap(Map<String, dynamic> map, {bool hydrated = false}) {
    List<Organization> _companies = [];
    map['companies'].forEach((company) {
      _companies.add(Organization.fromMap(company));
    });

    return OrganizationState(
      companies: _companies,
      status: Enums.toEnum(map['status'] ?? 'unknown', ECompanyStatus.values),
    );
  }
}
