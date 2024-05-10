
class Event {
  final String id;
  final String title;
  final DateTime date; // เพิ่มฟิลด์วันที่

  Event({required this.id, required this.title, required this.date}); // เพิ่ม date ใน constructor

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(), // บันทึกวันที่เป็น String
    };
  }

  factory Event.fromFirestore(Map<String, dynamic> firestore) {
    return Event(
      id: firestore['id'] ?? '',
      title: firestore['title'] ?? '',
      date: DateTime.parse(firestore['date'] as String), // แปลง String เป็น DateTime
    );
  }
}
