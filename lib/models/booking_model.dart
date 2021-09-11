import 'package:equatable/equatable.dart';

import 'models.dart';

class Booking extends Equatable {
  final String? id;
  final String? userId;
  // final String? userName;
  // final String? photoUrl;
  final Account? account;
  final DateTime? dateCre;
  final String? companyId;
  final String? roomId;
  final String? deskId;
  final DateTime? dateBook;
  final List<int> hoursBook;

  Booking({
    this.id,
    this.account,
    this.userId,
    // this.userName,
    // this.photoUrl,
    this.dateCre,
    this.companyId,
    this.roomId,
    this.deskId,
    this.dateBook,
    required this.hoursBook,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, userId, account, dateCre, companyId, roomId, deskId, dateBook, hoursBook];

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
      dateCre: map['dateCre'].toDate() as DateTime,
      companyId: map['companyId'] as String,
      roomId: map['roomId'] as String,
      deskId: map['deskId'] as String,
      userId: map['userId'] as String,
      dateBook: map['dateBook'].toDate() as DateTime,
      hoursBook: map['hoursBook'].cast<int>() as List<int>,
    );
  }

  Booking copyWith({
    String? id,
    String? userId,
    Account? account,
    DateTime? dateCre,
    String? companyId,
    String? roomId,
    String? deskId,
    DateTime? dateBook,
    List<int>? hoursBook,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      account: account ?? this.account,
      dateCre: dateCre ?? this.dateCre,
      companyId: companyId ?? this.companyId,
      roomId: roomId ?? this.roomId,
      deskId: deskId ?? this.deskId,
      dateBook: dateBook ?? this.dateBook,
      hoursBook: hoursBook ?? this.hoursBook,
    );
  }
}
