import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class _BaseBookingRepository {
  Future<void> create(Booking booking);
  Future<void> delete(Booking booking);
  Future<void> update(Booking booking);
  Stream<List<Booking>?> stream(String companyId, String roomId);
}

class BookingRepository extends _BaseBookingRepository {
  @override
  create(Booking booking) async {
    String path = "${Path.companies()}/${booking.companyId}/${Path.rooms()}/${booking.roomId}/${Path.bookings()}";

    CollectionReference ref = FirebaseFirestore.instance.collection(path).withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    DocumentReference doc = ref.doc();
    return await doc.set(booking.copyWith(id: doc.id));
  }

  @override
  delete(Booking booking) async {
    String path = "${Path.companies()}/${booking.companyId}/${Path.rooms()}/${booking.roomId}/${Path.bookings()}";
    CollectionReference ref = FirebaseFirestore.instance.collection(path).withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    return await ref.doc(booking.id).delete();
  }

  @override
  update(Booking booking) async {
    String path = "${Path.companies()}/${booking.companyId}/${Path.rooms()}/${booking.roomId}/${Path.bookings()}";
    CollectionReference ref = FirebaseFirestore.instance.collection(path).withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    return await ref.doc(booking.id).set(booking);
  }

  @override
  Stream<List<Booking>?> stream(String companyId, String roomId) {
    String path = "${Path.companies()}/$companyId}/${Path.rooms()}/$roomId/${Path.bookings()}";

    final ref = FirebaseFirestore.instance.collection(path).withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    return ref
        .where('companyId', isEqualTo: companyId)
        .where('roomId', isEqualTo: roomId)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }
}
