part of 'selected_organization_cubit.dart';

enum ESelectedOrganizationStatus { unknown, loading, succeed, empty }

class SelectedOrganizationState extends Equatable {
  final Organization? organization;
  final ESelectedOrganizationStatus status;

  SelectedOrganizationState({this.organization, required this.status});

  factory SelectedOrganizationState.unknown() {
    return SelectedOrganizationState(status: ESelectedOrganizationStatus.unknown);
  }

  factory SelectedOrganizationState.loading() {
    return SelectedOrganizationState(status: ESelectedOrganizationStatus.loading);
  }

  factory SelectedOrganizationState.succeed({required Organization company}) {
    return SelectedOrganizationState(status: ESelectedOrganizationStatus.succeed, organization: company);
  }

  @override
  List<Object?> get props => [organization, status];

  Map<String, dynamic> toMap({bool hydrated = false}) {
    return {
      'organization': this.organization?.toMap(hydrated: true) ?? null,
      'status': Enums.toText(this.status),
    };
  }

  factory SelectedOrganizationState.fromMap(Map<String, dynamic> map) {
    return SelectedOrganizationState(
      organization: map['organization'] != null ? Organization.fromMap(map['organization']) : null,
      status: Enums.toEnum(map['status'] ?? 'unknown', ESelectedOrganizationStatus.values),
    );
  }
}
