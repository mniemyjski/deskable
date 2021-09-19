import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/account_repository.dart';
import 'package:deskable/repositories/organization_repository.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'selected_organization_state.dart';

class SelectedOrganizationCubit extends HydratedCubit<SelectedOrganizationState> {
  final OrganizationCubit _organizationCubit;
  final AccountCubit _accountCubit;
  final AccountRepository _accountRepository;
  final OrganizationRepository _organizationRepository;
  late StreamSubscription<OrganizationState> _organizationSubscription;

  SelectedOrganizationCubit(
      {required OrganizationCubit organizationCubit,
      required OrganizationRepository organizationRepository,
      required AccountRepository accountRepository,
      required AccountCubit accountCubit})
      : _organizationCubit = organizationCubit,
        _accountCubit = accountCubit,
        _organizationRepository = organizationRepository,
        _accountRepository = accountRepository,
        super(SelectedOrganizationState.unknown()) {
    _init();
  }

  @override
  Future<void> close() {
    try {
      _organizationSubscription.cancel();
    } catch (e) {}

    return super.close();
  }

  void _init() {
    if (_organizationCubit.state.status == ECompanyStatus.succeed) {
      if (state.status != ESelectedCompanyStatus.succeed || state.company != _organizationCubit.state.companies!.first)
        emit(SelectedOrganizationState.succeed(company: _organizationCubit.state.companies!.first));
    }

    try {
      _organizationSubscription.cancel();
    } catch (e) {}
    _organizationSubscription = _organizationCubit.stream.listen((company) {
      if (company.status == ECompanyStatus.succeed) {
        if (state.status != ESelectedCompanyStatus.succeed || state.company != company.companies!.first)
          emit(SelectedOrganizationState.succeed(company: company.companies!.first));
      } else {
        if (state.status != ESelectedCompanyStatus.unknown) emit(SelectedOrganizationState.unknown());
      }
    });
  }

  change(int index) {
    emit(SelectedOrganizationState.loading());
    emit(SelectedOrganizationState.succeed(company: _organizationCubit.state.companies![index]));
  }

  next() {
    int index = _organizationCubit.state.companies!.indexOf(state.company!) + 1;

    if (_organizationCubit.state.companies!.length > index) {
      emit(SelectedOrganizationState.loading());
      emit(SelectedOrganizationState.succeed(company: _organizationCubit.state.companies![index]));
    }
  }

  back() {
    int index = _organizationCubit.state.companies!.indexOf(state.company!) - 1;

    if (index >= 0) {
      emit(SelectedOrganizationState.loading());
      emit(SelectedOrganizationState.succeed(company: _organizationCubit.state.companies![index]));
    }
  }

  Future<bool> isPossible(String accountId) async {
    if (_accountCubit.state.account!.uid == accountId) return false;

    return true;
  }

  addAdmin(Account account) async {
    List<String> ownerId = List.from(state.company!.ownersId);
    ownerId.add(account.uid);
    _organizationRepository.update(state.company!.copyWith(ownersId: ownerId));
  }

  removeOwnerById(String accountId) async {
    List<String> ownerId = List.from(state.company!.ownersId);
    ownerId.remove(accountId);
    _organizationRepository.update(state.company!.copyWith(ownersId: ownerId));
  }

  addEmployee(Account account) async {
    List<String> employeesId = List.from(state.company!.employeesId);
    employeesId.add(account.uid);
    _organizationRepository.update(state.company!.copyWith(employeesId: employeesId));
  }

  Future<bool> addEmployeeById(String id) async {
    Account? account = await _accountRepository.getAccountById(id);
    if (account == null) return false;

    List<String> employeesId = List.from(state.company!.employeesId);
    employeesId.add(account.uid);
    _organizationRepository.update(state.company!.copyWith(employeesId: employeesId));

    return true;
  }

  removeEmployeeById(String accountId) async {
    List<String> employeesId = List.from(state.company!.employeesId);
    employeesId.remove(accountId);
    _organizationRepository.update(state.company!.copyWith(employeesId: employeesId));
  }

  @override
  SelectedOrganizationState? fromJson(Map<String, dynamic> json) {
    return SelectedOrganizationState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SelectedOrganizationState state) {
    return state.toMap(hydrated: true);
  }
}
