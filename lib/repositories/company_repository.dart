import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class _BaseCompanyRepository {
  Future<void> create(Company company);
  Future<void> delete(Company company);
  Future<void> update(Company company);
  Stream<List<Company>?> stream(String uid);
}

final _ref = FirebaseFirestore.instance.collection(Path.companies()).withConverter<Company>(
      fromFirestore: (snapshot, _) => Company.fromMap(snapshot.data()!),
      toFirestore: (company, _) => company.toMap(),
    );

class CompanyRepository extends _BaseCompanyRepository {
  @override
  create(Company company) async {
    DocumentReference doc = _ref.doc();
    return await doc.set(company.copyWith(id: doc.id));
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
  Stream<List<Company>?> stream(String uid) => _ref.where('owner', isEqualTo: uid).snapshots().map((snap) => snap.docs.map((e) => e.data()).toList());
}
