import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class _BaseAccountRepository {
  streamMyAccount(String uid);
  getAccount(String id);
  Future<bool> nameAvailable(String name);
  Future<void> createAccount(Account account);
  Future<void> updateAccount(Account account);
  Future<void> deleteAccount(Account account);
}

class AccountRepository extends _BaseAccountRepository {
  final _ref = FirebaseFirestore.instance.collection(Path.accounts()).withConverter<Account>(
        fromFirestore: (snapshot, _) => Account.fromMap(snapshot.data()!),
        toFirestore: (account, _) => account.toMap(),
      );

  @override
  Future<void> createAccount(Account account) => _ref.doc(account.uid).set(account);

  @override
  Future<void> deleteAccount(Account account) => _ref.doc(account.uid).delete();

  @override
  Future<void> updateAccount(Account account) => _ref.doc(account.uid).set(account);

  @override
  getAccount(String id) => _ref.doc(id).get();

  @override
  Stream<Account?> streamMyAccount(String uid) => _ref.doc(uid).snapshots().map((account) => account.data());

  @override
  Future<bool> nameAvailable(String name) => _ref.where('name', isEqualTo: name).get().then((value) => value.docs.length > 0 ? false : true);
}
