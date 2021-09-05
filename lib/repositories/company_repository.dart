import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class _BaseCompanyRepository {
  Future<String> create(Company company);
  Future<void> delete(Company company);
  Future<void> update(Company company);
  Stream<List<Company?>> stream(List<String> companies);
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
  Stream<List<Company>> stream(List<String> companies) =>
      _ref.where(FieldPath.documentId, whereIn: companies).snapshots().map((snap) => snap.docs.map((e) => e.data()).toList());
}
