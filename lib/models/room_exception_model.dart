import 'package:equatable/equatable.dart';

enum ERoomExceptions {
  blockedDesk,
  blockedHour,
}

class RoomExceptions extends Equatable {
  final String? id;
  final DateTime datcre;
  final DateTime dateTime;
  final ERoomExceptions type;
  final int idDesk;
  final List<int> hours;
  final String description;

  RoomExceptions({
    this.id,
    required this.datcre,
    required this.dateTime,
    required this.type,
    required this.idDesk,
    required this.hours,
    this.description = '',
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'datcre': this.datcre,
      'dateTime': this.dateTime,
      'type': this.type,
      'idDesk': this.idDesk,
      'hours': this.hours,
      'description': this.description,
    };
  }

  factory RoomExceptions.fromMap(Map<String, dynamic> map) {
    return RoomExceptions(
      id: map['id'] as String,
      datcre: map['datcre'] as DateTime,
      dateTime: map['dateTime'] as DateTime,
      type: map['type'] as ERoomExceptions,
      idDesk: map['idDesk'] as int,
      hours: map['hours'] as List<int>,
      description: map['description'] as String,
    );
  }

  RoomExceptions copyWith({
    String? id,
    DateTime? datcre,
    DateTime? dateTime,
    ERoomExceptions? type,
    int? idDesk,
    List<int>? hours,
    String? description,
  }) {
    return RoomExceptions(
      id: id ?? this.id,
      datcre: datcre ?? this.datcre,
      dateTime: dateTime ?? this.dateTime,
      type: type ?? this.type,
      idDesk: idDesk ?? this.idDesk,
      hours: hours ?? this.hours,
      description: description ?? this.description,
    );
  }
}
