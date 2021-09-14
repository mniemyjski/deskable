import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String photoUrl;

  Account({
    this.uid = '',
    this.name = '',
    this.photoUrl = '',
    this.email = '',
  });

  @override
  List<Object> get props => [name, photoUrl, uid, email];

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'email': this.email,
      'name': this.name,
      'photoUrl': this.photoUrl,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      photoUrl: map['photoUrl'],
    );
  }

  Account copyWith({
    String? uid,
    String? email,
    String? name,
    String? photoUrl,
  }) {
    return Account(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
