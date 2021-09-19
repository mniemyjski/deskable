import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:collection";

abstract class _BaseAccountRepository {
  streamMyAccount(String uid);
  Future<Account?> getAccountById(String id);
  Future<Account?> getAccountByEmail(String email);
  Future<List<Account>> searchAccount(String txt);
  Future<bool> nameAvailable(String name);
  Future<void> createAccount(Account account);
  Future<void> updateAccount(Account account);
  Future<void> deleteAccount(Account account);
  Stream<List<Account>?> streamCompanyAccounts(String companyId);
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
  Future<Account?> getAccountById(String id) async {
    return await _ref.doc(id).get().then((value) => value.data());
  }

  @override
  Future<Account?> getAccountByEmail(String email) async {
    return await _ref.where('email', isEqualTo: email).get().then((value) {
      if (value.docs.isEmpty) return null;
      return value.docs.first.data();
    });
  }

  @override
  Stream<Account?> streamMyAccount(String uid) => _ref.doc(uid).snapshots().map((account) => account.data());

  @override
  Stream<List<Account>?> streamCompanyAccounts(String companyId) =>
      _ref.where('companies', arrayContains: companyId).snapshots().map((snap) => snap.docs.map((account) => account.data()).toList());

  @override
  Future<bool> nameAvailable(String name) => _ref.where('name', isEqualTo: name).get().then((value) => value.docs.length > 0 ? false : true);

  @override
  Future<List<Account>> searchAccount(String search) async {
    List<Account> email;
    List<Account> name;
    email = await _ref.orderBy('email').startAt([search]).endAt([search + '\uf8ff']).get().then((value) => value.docs.map((e) => e.data()).toList());
    name = await _ref.orderBy('name').startAt([search]).endAt([search + '\uf8ff']).get().then((value) => value.docs.map((e) => e.data()).toList());

    email = await _ref
        .where('email', isGreaterThanOrEqualTo: search)
        .where('email', isLessThan: search + 'z')
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
    name = await _ref
        .where('name', isGreaterThanOrEqualTo: search)
        .where('name', isLessThan: search + 'z')
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());

    List<Account> accounts = LinkedHashSet<Account>.from(email + name).toList();

    return accounts;
  }
}
