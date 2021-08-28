import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class _PreferenceRepository {
  streamPreference(String uid);
  createPreference(Preference preference);
  updatePreference(Preference preference);
}

class PreferenceRepository extends _PreferenceRepository {
  final _ref = FirebaseFirestore.instance.collection(Path.preferences()).withConverter<Preference>(
        fromFirestore: (snapshot, _) => Preference.fromMap(snapshot.data()!),
        toFirestore: (account, _) => account.toMap(),
      );

  @override
  createPreference(Preference preference) => _ref.doc(preference.uid).set(preference);

  @override
  updatePreference(Preference preference) => _ref.doc(preference.uid).set(preference);

  @override
  Stream<Preference?> streamPreference(String uid) => _ref.doc(uid).snapshots().map((account) => account.data());
}
