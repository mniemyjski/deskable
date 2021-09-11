import 'package:deskable/models/models.dart';
import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final String? id;
  final List<String> ownersId;
  final List<Account>? owners;
  final String name;
  final String description;

  Company({
    this.id,
    required this.ownersId,
    this.owners,
    required this.name,
    this.description = '',
  });

  factory Company.create({required String name, required String description}) {
    return Company(ownersId: [], name: name, description: description);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, ownersId, name, description];

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'owners': this.ownersId,
      'name': this.name,
      'description': this.description,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'] as String,
      ownersId: map['owners'].cast<String>() as List<String>,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  Company copyWith({
    String? id,
    List<String>? ownersId,
    List<Account>? owners,
    String? name,
    String? description,
  }) {
    return Company(
      id: id ?? this.id,
      ownersId: ownersId ?? this.ownersId,
      owners: owners ?? this.owners,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
