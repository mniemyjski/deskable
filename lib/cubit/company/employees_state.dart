part of '../company/employees_cubit.dart';

enum ECompanyEmployeesStatus { unknown, loading, succeed }

class EmployeesState extends Equatable {
  final List<Account> accounts;
  final ECompanyEmployeesStatus status;

  EmployeesState({required this.accounts, required this.status});

  @override
  List<Object> get props => [accounts, status];

  factory EmployeesState.unknown() {
    return EmployeesState(accounts: [], status: ECompanyEmployeesStatus.unknown);
  }

  factory EmployeesState.loading() {
    return EmployeesState(accounts: [], status: ECompanyEmployeesStatus.loading);
  }

  factory EmployeesState.succeed({required List<Account> accounts}) {
    return EmployeesState(accounts: accounts, status: ECompanyEmployeesStatus.succeed);
  }
}
