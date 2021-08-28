import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String? id;
  final String? userId;
  final DateTime dateCre;
  final String companyId;
  final String roomId;
  final int deskId;
  final DateTime dateBook;
  final List<int> hoursBook;

  Booking({
    this.id,
    this.userId,
    required this.dateCre,
    required this.companyId,
    required this.roomId,
    required this.deskId,
    required this.dateBook,
    required this.hoursBook,
  });

  @override
  bool get stringify => true;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'dateCre': this.dateCre,
      'companyId': this.companyId,
      'roomId': this.roomId,
      'deskId': this.deskId,
      'userId': this.userId,
      'dateBook': this.dateBook,
      'hoursBook': this.hoursBook,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] as String,
      dateCre: map['dateCre'] as DateTime,
      companyId: map['companyId'] as String,
      roomId: map['roomId'] as String,
      deskId: map['deskId'] as int,
      userId: map['userId'] as String,
      dateBook: map['dateBook'] as DateTime,
      hoursBook: map['hoursBook'] as List<int>,
    );
  }

  Booking copyWith({
    String? id,
    String? userId,
    DateTime? dateCre,
    String? companyId,
    String? roomId,
    int? deskId,
    DateTime? dateBook,
    List<int>? hoursBook,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dateCre: dateCre ?? this.dateCre,
      companyId: companyId ?? this.companyId,
      roomId: roomId ?? this.roomId,
      deskId: deskId ?? this.deskId,
      dateBook: dateBook ?? this.dateBook,
      hoursBook: hoursBook ?? this.hoursBook,
    );
  }
}
