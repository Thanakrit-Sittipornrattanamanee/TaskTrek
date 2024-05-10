import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planery_exclusive_demo_v1/Screen/Event.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ดึงข้อมูล events จาก Firestore
  Stream<List<Event>> getEvents() {
    return _db.collection('events').snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Event.fromFirestore(doc.data()))
          .toList(),
    );
  }

  // เพิ่มหรืออัปเดต event
  Future<void> setEvent(Event event) {
    var options = SetOptions(merge: true);
    return _db
        .collection('events')
        .doc(event.id)
        .set(event.toMap(), options);
  }

  // ลบ event
  Future<void> deleteEvent(String id) {
    return _db.collection('events').doc(id).delete();
  }
}
