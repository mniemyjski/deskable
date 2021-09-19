import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'models.dart';

class Booking extends Equatable {
  final String? id;
  final String? userId;
  final Account? account;
  final DateTime? dateCre;
  final String? organizationId;
  final String? roomId;
  final String? deskId;
  final DateTime? dateBook;
  final List<int> hoursBook;

  Booking({
    this.id,
    this.account,
    this.userId,
    this.dateCre,
    this.organizationId,
    this.roomId,
    this.deskId,
    this.dateBook,
    required this.hoursBook,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, userId, account, dateCre, organizationId, roomId, deskId, dateBook, hoursBook];

  Map<String, dynamic> toMap({bool hydrated = false}) {
    return {
      'id': this.id,
      'dateCre': hydrated ? this.dateCre!.toIso8601String() : this.dateCre,
      'organizationId': this.organizationId,
      'roomId': this.roomId,
      'deskId': this.deskId,
      'userId': this.userId,
      'dateBook': hydrated ? this.dateBook!.toIso8601String() : this.dateBook,
      'hoursBook': this.hoursBook,
      if (hydrated) 'account': this.account?.toMap(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map, {bool hydrated = false}) {
    DateTime? _dateCre;
    DateTime? _dateBook;
    if (map['dateCre']?.runtimeType == Timestamp) _dateCre = map['dateCre'].toDate();
    if (map['dateCre']?.runtimeType == String) _dateCre = DateTime.parse(map["dateCre"]);

    if (map['dateBook']?.runtimeType == Timestamp) _dateBook = map['dateBook'].toDate();
    if (map['dateBook']?.runtimeType == String) _dateBook = DateTime.parse(map["dateBook"]);

    return Booking(
      id: map['id'] as String,
      dateCre: _dateCre,
      organizationId: map['organizationId'] as String,
      roomId: map['roomId'] as String,
      deskId: map['deskId'] as String,
      userId: map['userId'] as String,
      dateBook: _dateBook,
      hoursBook: map['hoursBook'].cast<int>() as List<int>,
      account: hydrated ? Account.fromMap(map['account']) : null,
    );
  }

  Booking copyWith({
    String? id,
    String? userId,
    Account? account,
    DateTime? dateCre,
    String? organizationId,
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
      organizationId: organizationId ?? this.organizationId,
      roomId: roomId ?? this.roomId,
      deskId: deskId ?? this.deskId,
      dateBook: dateBook ?? this.dateBook,
      hoursBook: hoursBook ?? this.hoursBook,
    );
  }
}
