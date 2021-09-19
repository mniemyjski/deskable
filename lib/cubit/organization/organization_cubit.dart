import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deskable/cubit/cubit.dart';
import 'package:deskable/models/organization_model.dart';
import 'package:deskable/models/models.dart';
import 'package:deskable/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'organization_state.dart';

class OrganizationCubit extends HydratedCubit<OrganizationState> {
  final OrganizationRepository _organizationRepository;
  final AccountRepository _accountRepository;
  final AccountCubit _accountCubit;
  final bool _admin;

  final List<Account> _accounts = [];

  late StreamSubscription<List<Organization?>> _organizationSubscription;
  late StreamSubscription<AccountState> _accountSubscription;

  OrganizationCubit(
      {required OrganizationRepository organizationRepository,
      required AccountCubit accountCubit,
      required AccountRepository accountRepository,
      bool owner = false})
      : _organizationRepository = organizationRepository,
        _accountCubit = accountCubit,
        _accountRepository = accountRepository,
        _admin = owner,
        super(OrganizationState.unknown()) {
    _init();
  }

  void _init() {
    if (_accountCubit.state.status == EAccountStatus.created) _sub(_accountCubit.state);

    try {
      _accountSubscription.cancel();
    } catch (e) {}
    _accountSubscription = _accountCubit.stream.listen((event) {
      if (event.status == EAccountStatus.created) {
        _sub(event);
      } else {
        try {
          _organizationSubscription.cancel();
        } catch (e) {}
        if (state.status != ECompanyStatus.unknown) emit(OrganizationState.unknown());
      }
    });
  }

  void _sub(AccountState authState) {
    try {
      _organizationSubscription.cancel();
    } catch (e) {}
    _organizationSubscription = _organizationRepository.stream(accountId: _accountCubit.state.account!.uid, admin: _admin).listen((companies) async {
      if (companies.isNotEmpty) {
        if (state.status == ECompanyStatus.succeed) {
          if (_change(companies)) {
            List<Organization> _companies = await _buildCompanies(companies);
            emit(state.copyWith(companies: _companies, status: ECompanyStatus.succeed));
          }
        } else {
          List<Organization> _companies = await _buildCompanies(companies);
          emit(state.copyWith(companies: _companies, status: ECompanyStatus.succeed));
        }
      } else {
        if (state.status != ECompanyStatus.empty) emit(state.copyWith(companies: [], status: ECompanyStatus.empty));
      }
    });
  }

  bool _change(List<Organization> companies) {
    bool _change = false;
    for (var company in companies) {
      if (!state.organizations!.contains(company)) _change = true;
    }
    for (var company in state.organizations!) {
      if (!companies.contains(company)) _change = true;
    }
    return _change;
  }

  Future<List<Organization>> _buildCompanies(List<Organization> companies) async {
    List<Organization> _companies = [];

    for (var company in companies) {
      List<Account> _owners = [];
      List<Account> _employees = [];

      for (var ownerId in company.adminsId) {
        if (_accounts.contains(ownerId)) {
          Account account = _accounts.firstWhere((e) => e.uid == ownerId);
          _owners.add(account);
        } else {
          if (_accountCubit.state.status == EAccountStatus.created) {
            Account? account = await _accountRepository.getAccountById(ownerId);
            if (account != null) {
              _accounts.add(account);
              _owners.add(account);
            }
          }
        }
      }

      for (var employeeId in company.usersId) {
        if (_accounts.contains(employeeId)) {
          Account account = _accounts.firstWhere((e) => e.uid == employeeId);
          _employees.add(account);
        } else {
          if (_accountCubit.state.status == EAccountStatus.created) {
            Account? account = await _accountRepository.getAccountById(employeeId);
            if (account != null) {
              _accounts.add(account);
              _employees.add(account);
            }
          }
        }
      }

      _owners.sort((a, b) => a.name.compareTo(b.name));
      _employees.sort((a, b) => a.name.compareTo(b.name));

      _companies.add(company.copyWith(admins: _owners, users: _employees));
      _companies.sort((a, b) => a.name.compareTo(b.name));
    }
    return _companies;
  }

  @override
  Future<void> close() {
    try {
      _organizationSubscription.cancel();
    } catch (e) {}
    try {
      _accountSubscription.cancel();
    } catch (e) {}

    return super.close();
  }

  Future<void> create(Organization company) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      await _organizationRepository.create(company.copyWith(
        adminsId: [_accountCubit.state.account!.uid],
        usersId: [_accountCubit.state.account!.uid],
      ));
    }
  }

  Future<void> update(Organization company) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      return await _organizationRepository.update(company);
    }
  }

  Future<void> delete(Organization company) async {
    if (_accountCubit.state.status == EAccountStatus.created) {
      return await _organizationRepository.delete(company);
    }
  }

  @override
  OrganizationState? fromJson(Map<String, dynamic> json) {
    return OrganizationState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(OrganizationState state) {
    return state.toMap(hydrated: true);
  }
}
