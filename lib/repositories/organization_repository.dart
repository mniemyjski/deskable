import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class _BaseOrganizationRepository {
  Future<String> create(Organization company);
  Future<void> delete(Organization company);
  Future<void> update(Organization company);
  Stream<List<Organization?>> stream({required String accountId, bool owner = false});
}

final _ref = FirebaseFirestore.instance.collection(Path.companies()).withConverter<Organization>(
      fromFirestore: (snapshot, _) => Organization.fromMap(snapshot.data()!),
      toFirestore: (company, _) => company.toMap(),
    );

class OrganizationRepository extends _BaseOrganizationRepository {
  @override
  Future<String> create(Organization company) async {
    DocumentReference doc = _ref.doc();
    await doc.set(company.copyWith(id: doc.id));
    return doc.id;
  }

  @override
  delete(Organization company) async {
    return await _ref.doc(company.id).delete();
  }

  @override
  update(Organization company) async {
    return await _ref.doc(company.id).set(company);
  }

  @override
  Stream<List<Organization>> stream({required String accountId, bool owner = false}) {
    if (owner)
      return _ref.where('ownersId', arrayContains: accountId).snapshots().map((snap) {
        return snap.docs.isNotEmpty ? snap.docs.map((e) => e.data()).toList() : [];
      });

    return _ref.where('employeesId', arrayContains: accountId).snapshots().map((snap) {
      return snap.docs.isNotEmpty ? snap.docs.map((e) => e.data()).toList() : [];
    });
  }
}
