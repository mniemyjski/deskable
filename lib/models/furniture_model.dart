import 'package:equatable/equatable.dart';

// enum EFurnitureType { computer, laptop }

class Furniture extends Equatable {
  final String id;
  final int position;
  final String path;
  final int rotation;
  final bool isEmpty;
  final String name;
  final String description;

  Furniture({
    required this.id,
    required this.position,
    this.isEmpty = false,
    this.rotation = 0,
    this.path = '',
    this.name = '',
    this.description = '',
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, position, isEmpty, rotation, path, name, description];

  Furniture copyWith({
    String? id,
    int? position,
    String? path,
    int? rotation,
    bool? isEmpty,
    String? name,
    String? description,
  }) {
    return Furniture(
      id: id ?? this.id,
      position: position ?? this.position,
      path: path ?? this.path,
      rotation: rotation ?? this.rotation,
      isEmpty: isEmpty ?? this.isEmpty,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'position': this.position,
      'path': this.path,
      'rotation': this.rotation,
      'isEmpty': this.isEmpty,
      'name': this.name,
      'description': this.description,
    };
  }

  factory Furniture.fromMap(Map<String, dynamic> map) {
    return Furniture(
      id: map['id'] as String,
      position: map['position'] as int,
      path: map['path'] as String,
      rotation: map['rotation'] as int,
      isEmpty: map['isEmpty'] as bool,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }
}
