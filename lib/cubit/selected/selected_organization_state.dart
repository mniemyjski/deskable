part of 'selected_organization_cubit.dart';

enum ESelectedCompanyStatus { unknown, loading, succeed, empty }

class SelectedOrganizationState extends Equatable {
  final Organization? company;
  final ESelectedCompanyStatus status;

  SelectedOrganizationState({this.company, required this.status});

  factory SelectedOrganizationState.unknown() {
    return SelectedOrganizationState(status: ESelectedCompanyStatus.unknown);
  }

  factory SelectedOrganizationState.loading() {
    return SelectedOrganizationState(status: ESelectedCompanyStatus.loading);
  }

  factory SelectedOrganizationState.succeed({required Organization company}) {
    return SelectedOrganizationState(status: ESelectedCompanyStatus.succeed, company: company);
  }

  @override
  List<Object?> get props => [company, status];

  Map<String, dynamic> toMap({bool hydrated = false}) {
    return {
      'organization': this.company?.toMap(hydrated: true) ?? null,
      'status': Enums.toText(this.status),
    };
  }

  factory SelectedOrganizationState.fromMap(Map<String, dynamic> map) {
    return SelectedOrganizationState(
      company: map['organization'] != null ? Organization.fromMap(map['organization']) : null,
      status: Enums.toEnum(map['status'] ?? 'unknown', ESelectedCompanyStatus.values),
    );
  }
}
