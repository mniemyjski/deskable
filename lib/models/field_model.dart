import 'package:equatable/equatable.dart';

class Field extends Equatable {
  final int id;
  final String path;
  final int rotation;
  final bool isEmpty;
  final String name;
  final String description;

  Field({
    required this.id,
    this.isEmpty = false,
    this.rotation = 0,
    this.path = '',
    this.name = '',
    this.description = '',
  });

  @override
  bool get stringify => true;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'path': this.path,
      'rotation': this.rotation,
      'isEmpty': this.isEmpty,
      'name': this.name,
      'description': this.description,
    };
  }

  factory Field.fromMap(Map<String, dynamic> map) {
    return Field(
      id: map['id'] as int,
      path: map['path'] as String,
      rotation: map['rotation'] as int,
      isEmpty: map['isEmpty'] as bool,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }
}
