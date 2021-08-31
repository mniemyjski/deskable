import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String uid;
  final String name;
  final String photoUrl;
  final List<String> companies;

  Account({
    this.uid = '',
    this.name = '',
    this.photoUrl = '',
    required this.companies,
  });

  @override
  List<Object> get props => [name, photoUrl, uid, companies];

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'name': this.name,
      'photoUrl': this.photoUrl,
      'companies': this.companies,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    //TODO .cast<String>() WHEN IS NULL?

    return Account(
      uid: map['uid'] as String,
      name: map['name'] as String,
      photoUrl: map['photoUrl'] as String,
      companies: map['companies'].cast<String>() as List<String>,
    );
  }

  Account copyWith({
    String? uid,
    String? name,
    String? photoUrl,
    List<String>? companies,
  }) {
    return Account(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      companies: companies ?? this.companies,
    );
  }
}
