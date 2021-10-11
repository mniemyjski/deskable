import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:equatable/equatable.dart';

import 'models.dart';

class Booking extends Equatable {
  final String? id;
  final String? userId;
  final Account? account;
  final DateTime? dateCre;
  final String? organizationId;
  final String? roomId;
  final String? furnitureId;
  final Organization? organization;
  final Room? room;
  final Furniture? furniture;
  final DateTime? dateBooked;
  final List<int> hoursBooked;

  Booking({
    this.id,
    this.account,
    this.userId,
    this.dateCre,
    this.organizationId,
    this.roomId,
    this.furnitureId,
    this.organization,
    this.room,
    this.furniture,
    this.dateBooked,
    required this.hoursBooked,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, userId, account, dateCre, organizationId, roomId, furnitureId, dateBooked, hoursBooked];

  Map<String, dynamic> toMap({bool hydrated = false}) {
    return {
      'id': this.id,
      'dateCre': hydrated ? this.dateCre!.toIso8601String() : this.dateCre,
      'organizationId': this.organizationId,
      'roomId': this.roomId,
      'furnitureId': this.furnitureId,
      'userId': this.userId,
      'dateBooked': hydrated ? this.dateBooked!.toIso8601String() : this.dateBooked,
      'hoursBooked': this.hoursBooked,
      if (hydrated) 'account': this.account?.toMap(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map, {bool hydrated = false}) {
    DateTime? _dateCre;
    DateTime? _dateBooked;
    if (map['dateCre']?.runtimeType == Timestamp) _dateCre = map['dateCre'].toDate();
    if (map['dateCre']?.runtimeType == String) _dateCre = DateTime.parse(map["dateCre"]);

    if (map['dateBooked']?.runtimeType == Timestamp) _dateBooked = map['dateBooked'].toDate();
    if (map['dateBooked']?.runtimeType == String) _dateBooked = DateTime.parse(map["dateBooked"]);

    return Booking(
      id: map['id'] as String,
      dateCre: _dateCre,
      organizationId: map['organizationId'] as String,
      roomId: map['roomId'] as String,
      furnitureId: map['furnitureId'] as String,
      userId: map['userId'] as String,
      dateBooked: _dateBooked,
      hoursBooked: map['hoursBooked'].cast<int>() as List<int>,
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
    String? furnitureId,
    DateTime? dateBooked,
    List<int>? hoursBooked,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      account: account ?? this.account,
      dateCre: dateCre ?? this.dateCre,
      organizationId: organizationId ?? this.organizationId,
      roomId: roomId ?? this.roomId,
      furnitureId: furnitureId ?? this.furnitureId,
      dateBooked: dateBooked ?? this.dateBooked,
      hoursBooked: hoursBooked ?? this.hoursBooked,
    );
  }
}
