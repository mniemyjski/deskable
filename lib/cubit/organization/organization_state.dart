part of 'organization_cubit.dart';

enum ECompanyStatus { unknown, loading, succeed, empty }

class OrganizationState extends Equatable {
  final List<Organization>? organizations;
  final ECompanyStatus status;

  OrganizationState({required this.organizations, required this.status});

  factory OrganizationState.unknown() {
    return OrganizationState(status: ECompanyStatus.unknown, organizations: []);
  }

  @override
  List<Object?> get props => [organizations, status];

  OrganizationState copyWith({
    List<Organization>? companies,
    ECompanyStatus? status,
  }) {
    return OrganizationState(
      organizations: companies ?? this.organizations,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap({bool hydrated = false}) {
    List<Map<String, dynamic>> _organizations = [];
    this.organizations!.forEach((company) {
      _organizations.add(company.toMap(hydrated: hydrated));
    });

    return {
      'organizations': _organizations,
      'status': Enums.toText(this.status),
    };
  }

  factory OrganizationState.fromMap(Map<String, dynamic> map, {bool hydrated = false}) {
    List<Organization> _organizations = [];
    map['organizations'].forEach((company) {
      _organizations.add(Organization.fromMap(company));
    });

    return OrganizationState(
      organizations: _organizations,
      status: Enums.toEnum(map['status'] ?? 'unknown', ECompanyStatus.values),
    );
  }
}
