import 'dart:async';

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
      if (state.status != ESelectedOrganizationStatus.succeed || state.organization != _organizationCubit.state.organizations!.first)
        emit(SelectedOrganizationState.succeed(company: _organizationCubit.state.organizations!.first));
    }

    try {
      _organizationSubscription.cancel();
    } catch (e) {}
    _organizationSubscription = _organizationCubit.stream.listen((company) {
      if (company.status == ECompanyStatus.succeed) {
        if (state.status != ESelectedOrganizationStatus.succeed || state.organization != company.organizations!.first)
          emit(SelectedOrganizationState.succeed(company: company.organizations!.first));
      } else {
        if (state.status != ESelectedOrganizationStatus.unknown) emit(SelectedOrganizationState.unknown());
      }
    });
  }

  change(int index) {
    emit(SelectedOrganizationState.loading());
    emit(SelectedOrganizationState.succeed(company: _organizationCubit.state.organizations![index]));
  }

  next() {
    int index = _organizationCubit.state.organizations!.indexOf(state.organization!) + 1;

    if (_organizationCubit.state.organizations!.length > index) {
      emit(SelectedOrganizationState.loading());
      emit(SelectedOrganizationState.succeed(company: _organizationCubit.state.organizations![index]));
    }
  }

  back() {
    int index = _organizationCubit.state.organizations!.indexOf(state.organization!) - 1;

    if (index >= 0) {
      emit(SelectedOrganizationState.loading());
      emit(SelectedOrganizationState.succeed(company: _organizationCubit.state.organizations![index]));
    }
  }

  Future<bool> isPossible(String accountId) async {
    if (_accountCubit.state.account!.uid == accountId) return false;

    return true;
  }

  Future<void> addAdmin(Account account) async {
    List<String> ownerId = List.from(state.organization!.adminsId);
    ownerId.add(account.uid);
    return await _organizationRepository.update(state.organization!.copyWith(adminsId: ownerId));
  }

  removeOwnerById(String accountId) async {
    List<String> ownerId = List.from(state.organization!.adminsId);
    ownerId.remove(accountId);
    _organizationRepository.update(state.organization!.copyWith(adminsId: ownerId));
  }

  Future<void> addEmployee(Account account) async {
    List<String> employeesId = List.from(state.organization!.usersId);
    employeesId.add(account.uid);
    return await _organizationRepository.update(state.organization!.copyWith(usersId: employeesId));
  }

  Future<bool> addEmployeeById(String id) async {
    Account? account = await _accountRepository.getAccountById(id);
    if (account == null) return false;

    List<String> employeesId = List.from(state.organization!.usersId);
    employeesId.add(account.uid);
    _organizationRepository.update(state.organization!.copyWith(usersId: employeesId));

    return true;
  }

  removeEmployeeById(String accountId) async {
    List<String> employeesId = List.from(state.organization!.usersId);
    employeesId.remove(accountId);
    _organizationRepository.update(state.organization!.copyWith(usersId: employeesId));
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
