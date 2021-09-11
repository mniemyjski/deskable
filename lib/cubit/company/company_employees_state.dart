part of '../company/company_employees_cubit.dart';

enum ECompanyEmployeesStatus { unknown, loading, succeed }

class CompanyEmployeesState extends Equatable {
  final List<Account> accounts;
  final ECompanyEmployeesStatus status;

  CompanyEmployeesState({required this.accounts, required this.status});

  @override
  List<Object> get props => [accounts, status];

  factory CompanyEmployeesState.unknown() {
    return CompanyEmployeesState(accounts: [], status: ECompanyEmployeesStatus.unknown);
  }

  factory CompanyEmployeesState.loading() {
    return CompanyEmployeesState(accounts: [], status: ECompanyEmployeesStatus.loading);
  }

  factory CompanyEmployeesState.succeed({required List<Account> accounts}) {
    return CompanyEmployeesState(accounts: accounts, status: ECompanyEmployeesStatus.succeed);
  }
}
