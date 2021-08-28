import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final String? id;
  final String? owner;
  final String name;
  final String description;

  Company({
    this.id,
    this.owner,
    required this.name,
    this.description = '',
  });

  @override
  bool get stringify => true;

  @override
  // TODO: implement props
  List<Object?> get props => [id, owner, name, description];

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'owner': this.owner,
      'name': this.name,
      'description': this.description,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'] as String,
      owner: map['owner'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  Company copyWith({
    String? id,
    String? owner,
    String? name,
    String? description,
  }) {
    return Company(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
