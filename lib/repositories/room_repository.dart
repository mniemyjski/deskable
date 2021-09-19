import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

abstract class _BaseRoomRepository {
  Future<void> create(Room room);
  Future<void> delete(Room room);
  Future<void> update(Room room);
  Stream<List<Room?>> stream(String companyId);
}

class RoomRepository extends _BaseRoomRepository {
  @override
  create(Room room) async {
    String path = "${Path.companies()}/${room.organizationId}/${Path.rooms()}";

    final ref = FirebaseFirestore.instance.collection(path).withConverter<Room>(
          fromFirestore: (snapshot, _) => Room.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    DocumentReference doc = ref.doc();
    return await ref.doc(doc.id).set(room.copyWith(id: doc.id));
  }

  @override
  delete(Room room) async {
    String path = "${Path.companies()}/${room.organizationId}/${Path.rooms()}";

    final ref = FirebaseFirestore.instance.collection(path).withConverter<Room>(
          fromFirestore: (snapshot, _) => Room.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );
    return await ref.doc(room.id).delete();
  }

  @override
  update(Room room) async {
    String path = "${Path.companies()}/${room.organizationId}/${Path.rooms()}";
    final ref = FirebaseFirestore.instance.collection(path).withConverter<Room>(
          fromFirestore: (snapshot, _) => Room.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );
    return await ref.doc(room.id).set(room);
  }

  @override
  Stream<List<Room>> stream(String companyId) {
    String path = "${Path.companies()}/$companyId/${Path.rooms()}";

    final ref = FirebaseFirestore.instance.collection(path).withConverter<Room>(
          fromFirestore: (snapshot, _) => Room.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    return ref.where('organizationId', isEqualTo: companyId).snapshots().map((snap) => snap.docs.map((e) => e.data()).toList());
  }
}
