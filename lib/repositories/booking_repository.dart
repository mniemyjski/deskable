import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

// extension WhereNotInExt<T> on Iterable<T> {
//   Iterable<T> whereNotIn(Iterable<T> reject) {
//     final rejectSet = reject.toSet();
//     return where((el) => !rejectSet.contains(el));
//   }
// }

abstract class _BaseBookingRepository {
  Future<void> create(Booking booking);
  Future<void> delete(Booking booking);
  Future<void> update(Booking booking);
  Stream<List<Booking>?> stream({required String companyId, required String roomId, required DateTime dateBook});
  Stream<List<Booking>> streamIncomingBooking({required String organizationId, required DateTime dateTime, required String userId});
}

class BookingRepository extends _BaseBookingRepository {
  @override
  create(Booking booking) async {
    String path = "${Path.companies()}/${booking.organizationId}/${Path.rooms()}/${booking.roomId}/${Path.bookings()}";

    CollectionReference ref = FirebaseFirestore.instance.collection(path).withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    DocumentReference doc = ref.doc(booking.id);
    return await doc.set(booking.copyWith(
      id: doc.id,
      dateCre: DateTime.now(),
      dateBook: DateTime(booking.dateBook!.year, booking.dateBook!.month, booking.dateBook!.day),
    ));
  }

  @override
  delete(Booking booking) async {
    String path = "${Path.companies()}/${booking.organizationId}/${Path.rooms()}/${booking.roomId}/${Path.bookings()}";
    CollectionReference _ref = FirebaseFirestore.instance.collection(path).withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    return await _ref.doc(booking.id).delete();
  }

  @override
  update(Booking booking) async {
    String path = "${Path.companies()}/${booking.organizationId}/${Path.rooms()}/${booking.roomId}/${Path.bookings()}";
    CollectionReference _ref = FirebaseFirestore.instance.collection(path).withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    return await _ref.doc(booking.id).set(booking);
  }

  @override
  Stream<List<Booking>?> stream({required String companyId, required String roomId, required DateTime dateBook}) {
    final ref = FirebaseFirestore.instance.collectionGroup(Path.bookings()).withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    return ref
        .where('organizationId', isEqualTo: companyId)
        .where('dateBook', isEqualTo: dateBook)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  @override
  Stream<List<Booking>> streamIncomingBooking({required String organizationId, required DateTime dateTime, required String userId}) {
    final ref = FirebaseFirestore.instance.collectionGroup(Path.bookings()).withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    return ref
        .where('organizationId', isEqualTo: organizationId)
        .where('userId', isEqualTo: userId)
        .where('dateBook', isGreaterThan: dateTime)
        .orderBy('dateBook')
        .limit(10)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }
}
