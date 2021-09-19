import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:equatable/equatable.dart';

class Organization extends Equatable {
  final String? id;
  final List<String> adminsId;
  final List<Account> admins;
  final List<String> usersId;
  final List<Account> users;
  final String name;
  final String description;

  Organization({
    this.id,
    required this.adminsId,
    required this.admins,
    required this.usersId,
    required this.users,
    required this.name,
    this.description = '',
  });

  factory Organization.create({required String name, required String description}) {
    return Organization(adminsId: [], usersId: [], admins: [], users: [], name: name, description: description);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, adminsId, usersId, name, description];

  Map<String, dynamic> toMap({bool hydrated = false}) {
    if (hydrated) {
      List<Map<String, dynamic>> _admins = [];
      List<Map<String, dynamic>> _users = [];

      admins.forEach((element) {
        _admins.add(element.toMap());
      });
      users.forEach((element) {
        _users.add(element.toMap());
      });

      return {
        'id': this.id,
        'adminsId': this.adminsId,
        'admins': _admins,
        'usersId': this.usersId,
        'users': _users,
        'name': this.name,
        'description': this.description,
      };
    }

    return {
      'id': this.id,
      'adminsId': this.adminsId,
      'usersId': this.usersId,
      'name': this.name,
      'description': this.description,
    };
  }

  factory Organization.fromMap(Map<String, dynamic> map) {
    List<Account> _admins = [];
    List<Account> _users = [];

    map['admins']?.forEach((element) {
      _admins.add(Account.fromMap(element));
    });

    map['users']?.forEach((element) {
      _users.add(Account.fromMap(element));
    });

    return Organization(
      id: map['id'] as String,
      adminsId: map['adminsId'].cast<String>() as List<String>,
      admins: _admins,
      usersId: map['usersId'].cast<String>() as List<String>,
      users: _users,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  Organization copyWith({
    String? id,
    List<String>? adminsId,
    List<Account>? admins,
    List<String>? usersId,
    List<Account>? users,
    String? name,
    String? description,
  }) {
    return Organization(
      id: id ?? this.id,
      adminsId: adminsId ?? this.adminsId,
      admins: admins ?? this.admins,
      usersId: usersId ?? this.usersId,
      users: users ?? this.users,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
