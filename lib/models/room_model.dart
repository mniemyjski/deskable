import 'package:equatable/equatable.dart';
import 'models.dart';

class Room extends Equatable {
  final String? id;
  final String? companyId;

  final int x;
  final int y;

  final int open;
  final int close;

  final List<Furniture> furniture;

  final String name;
  final String description;

  Room({
    this.id,
    this.companyId,
    required this.x,
    required this.y,
    required this.open,
    required this.close,
    required this.furniture,
    required this.name,
    this.description = '',
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toMap() {
    List _furniture = [];
    this.furniture.forEach((element) {
      _furniture.add(element.toMap());
    });

    return {
      'id': this.id,
      'companyId': this.companyId,
      'x': this.x,
      'y': this.y,
      'open': this.open,
      'close': this.close,
      'furniture': _furniture,
      'name': this.name,
      'description': this.description,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    List<Furniture> _furniture = [];
    map['furniture'].forEach((element) {
      _furniture.add(Furniture.fromMap(element));
    });

    return Room(
      id: map['id'] as String,
      companyId: map['companyId'] as String,
      x: map['x'] as int,
      y: map['y'] as int,
      open: map['open'] as int,
      close: map['close'] as int,
      furniture: _furniture,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  Room copyWith({
    String? id,
    String? companyId,
    int? x,
    int? y,
    int? open,
    int? close,
    List<Furniture>? fields,
    String? name,
    String? description,
  }) {
    return Room(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      x: x ?? this.x,
      y: y ?? this.y,
      open: open ?? this.open,
      close: close ?? this.close,
      furniture: fields ?? this.furniture,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
