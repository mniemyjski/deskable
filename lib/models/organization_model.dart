import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:equatable/equatable.dart';

class Organization extends Equatable {
  final String? id;
  final List<String> ownersId;
  final List<Account> owners;
  final List<String> employeesId;
  final List<Account> employees;
  final String name;
  final String description;

  Organization({
    this.id,
    required this.ownersId,
    required this.owners,
    required this.employeesId,
    required this.employees,
    required this.name,
    this.description = '',
  });

  factory Organization.create({required String name, required String description}) {
    return Organization(ownersId: [], employeesId: [], owners: [], employees: [], name: name, description: description);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, ownersId, employeesId, name, description];

  Map<String, dynamic> toMap({bool hydrated = false}) {
    if (hydrated) {
      List<Map<String, dynamic>> _owners = [];
      List<Map<String, dynamic>> _employees = [];

      owners.forEach((element) {
        _owners.add(element.toMap());
      });
      employees.forEach((element) {
        _employees.add(element.toMap());
      });

      return {
        'id': this.id,
        'ownersId': this.ownersId,
        'owners': _owners,
        'employeesId': this.employeesId,
        'employees': _employees,
        'name': this.name,
        'description': this.description,
      };
    }

    return {
      'id': this.id,
      'ownersId': this.ownersId,
      'employeesId': this.employeesId,
      'name': this.name,
      'description': this.description,
    };
  }

  factory Organization.fromMap(Map<String, dynamic> map) {
    List<Account> _owners = [];
    List<Account> _employees = [];

    map['owners']?.forEach((element) {
      _owners.add(Account.fromMap(element));
    });

    map['employees']?.forEach((element) {
      _employees.add(Account.fromMap(element));
    });

    return Organization(
      id: map['id'] as String,
      ownersId: map['ownersId'].cast<String>() as List<String>,
      owners: _owners,
      employeesId: map['employeesId'].cast<String>() as List<String>,
      employees: _employees,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  Organization copyWith({
    String? id,
    List<String>? ownersId,
    List<Account>? owners,
    List<String>? employeesId,
    List<Account>? employees,
    String? name,
    String? description,
  }) {
    return Organization(
      id: id ?? this.id,
      ownersId: ownersId ?? this.ownersId,
      owners: owners ?? this.owners,
      employeesId: employeesId ?? this.employeesId,
      employees: employees ?? this.employees,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
