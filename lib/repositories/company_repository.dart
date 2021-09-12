import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class _BaseCompanyRepository {
  Future<String> create(Company company);
  Future<void> delete(Company company);
  Future<void> update(Company company);
  Stream<List<Company?>> stream({required String accountId, bool owner = false});
}

final _ref = FirebaseFirestore.instance.collection(Path.companies()).withConverter<Company>(
      fromFirestore: (snapshot, _) => Company.fromMap(snapshot.data()!),
      toFirestore: (company, _) => company.toMap(),
    );

class CompanyRepository extends _BaseCompanyRepository {
  @override
  Future<String> create(Company company) async {
    DocumentReference doc = _ref.doc();
    await doc.set(company.copyWith(id: doc.id));
    return doc.id;
  }

  @override
  delete(Company company) async {
    return await _ref.doc(company.id).delete();
  }

  @override
  update(Company company) async {
    return await _ref.doc(company.id).set(company);
  }

  @override
  Stream<List<Company>> stream({required String accountId, bool owner = false}) {
    if (owner)
      return _ref.where('ownersId', arrayContains: accountId).snapshots().map((snap) {
        return snap.docs.isNotEmpty ? snap.docs.map((e) => e.data()).toList() : [];
      });

    return _ref.where('employeesId', arrayContains: accountId).snapshots().map((snap) {
      return snap.docs.isNotEmpty ? snap.docs.map((e) => e.data()).toList() : [];
    });
  }
}
