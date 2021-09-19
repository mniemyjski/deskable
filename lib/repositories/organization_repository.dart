import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class _BaseOrganizationRepository {
  Future<String> create(Organization organization);
  Future<void> delete(Organization organization);
  Future<void> update(Organization organization);
  Stream<List<Organization?>> stream({required String accountId, bool admin = false});
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
  delete(Organization organization) async {
    return await _ref.doc(organization.id).delete();
  }

  @override
  update(Organization organization) async {
    return await _ref.doc(organization.id).set(organization);
  }

  @override
  Stream<List<Organization>> stream({required String accountId, bool admin = false}) {
    if (admin)
      return _ref.where('adminsId', arrayContains: accountId).snapshots().map((snap) {
        return snap.docs.isNotEmpty ? snap.docs.map((e) => e.data()).toList() : [];
      });

    return _ref.where('usersId', arrayContains: accountId).snapshots().map((snap) {
      return snap.docs.isNotEmpty ? snap.docs.map((e) => e.data()).toList() : [];
    });
  }
}
