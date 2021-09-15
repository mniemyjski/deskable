import 'package:deskable/utilities/constants.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:equatable/equatable.dart';

enum EFurnitureType { computer, laptop, empty }

class Furniture extends Equatable {
  final String id;
  final int position;
  final EFurnitureType type;
  final int rotation;
  final String name;
  final String description;

  Furniture({
    required this.id,
    required this.position,
    required this.type,
    this.rotation = 0,
    this.name = '',
    this.description = '',
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, position, rotation, name, description, type];

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'position': this.position,
      'type': Enums.toText(this.type),
      'rotation': this.rotation,
      'name': this.name,
      'description': this.description,
    };
  }

  factory Furniture.fromMap(Map<String, dynamic> map) {
    return Furniture(
      id: map['id'] as String,
      position: map['position'] as int,
      type: Enums.toEnum(map['type'], EFurnitureType.values),
      rotation: map['rotation'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  String path() {
    switch (this.type) {
      case EFurnitureType.computer:
        return Constants.computer();

      case EFurnitureType.laptop:
        return Constants.laptop();

      case EFurnitureType.empty:
        return '';
    }
  }

  Furniture copyWith({
    String? id,
    int? position,
    EFurnitureType? type,
    int? rotation,
    String? name,
    String? description,
  }) {
    return Furniture(
      id: id ?? this.id,
      position: position ?? this.position,
      type: type ?? this.type,
      rotation: rotation ?? this.rotation,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
