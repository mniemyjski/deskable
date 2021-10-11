import 'package:deskable/models/models.dart';
import 'package:deskable/utilities/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

abstract class _BaseBookingRepository {
  Future<void> create(Booking booking);
  Future<void> delete(Booking booking);
  Future<void> update(Booking booking);
  Stream<List<Booking>?> streamTodayBooking({required String companyId, required String roomId, required DateTime dateBook});
  Stream<List<Booking>> streamIncomingBooking({required String organizationId, required String userId});
  Stream<List<Booking>> streamMonthBooking({required String organizationId, required String userId, required DateTime startDate});
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
      dateBooked: DateTime(booking.dateBooked!.year, booking.dateBooked!.month, booking.dateBooked!.day),
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
  Stream<List<Booking>?> streamTodayBooking({required String companyId, required String roomId, required DateTime dateBook}) {
    final ref = FirebaseFirestore.instance.collectionGroup(Path.bookings()).withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    return ref
        .where('organizationId', isEqualTo: companyId)
        .where('dateBooked', isEqualTo: dateBook)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  @override
  Stream<List<Booking>> streamIncomingBooking({required String organizationId, required String userId}) {
    DateTime dateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: -1));

    final ref = FirebaseFirestore.instance.collectionGroup(Path.bookings()).withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    return ref
        .where('organizationId', isEqualTo: organizationId)
        .where('userId', isEqualTo: userId)
        .where('dateBooked', isGreaterThan: dateTime)
        .orderBy('dateBooked')
        .limit(10)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  @override
  Stream<List<Booking>> streamMonthBooking({required String organizationId, required String userId, required DateTime startDate}) {
    DateTime start = DateTime(startDate.year, startDate.month, 1);
    DateTime end = DateTime(startDate.year, startDate.month, DateTime(startDate.year, startDate.month + 1, 0).day).add(Duration(days: 1));

    final ref = FirebaseFirestore.instance.collectionGroup(Path.bookings()).withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap(),
        );

    return ref
        .where('organizationId', isEqualTo: organizationId)
        .where('dateBooked', isGreaterThan: start)
        .where('dateBooked', isLessThan: end)
        .orderBy('dateBooked')
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }
}
