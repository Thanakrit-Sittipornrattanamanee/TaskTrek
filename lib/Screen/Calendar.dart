import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'firestore_service.dart';
import 'Event.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat format) {
              setState(() {
                format = format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = DateTime(selectDay.year, selectDay.month, selectDay.day);
                focusedDay = focusDay;
              });
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            eventLoader: _getEventsfromDay,
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
  child: ListView(
    children: _getEventsfromDay(selectedDay)
        .map((Event event) => ListTile(
            title: Container(
              padding: EdgeInsets.all(8.0),  // ใส่ padding ภายในกล่อง
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),  // ใส่ margin รอบกล่อง
              decoration: BoxDecoration(
                color: Colors.grey[200],  // กำหนดสีพื้นหลังของกล่อง
                border: Border.all(color: Colors.blue),  // กำหนดขอบของกล่อง
                borderRadius: BorderRadius.circular(5.0),  // กำหนดให้มุมของกล่องเป็นมน
              ),
              child: Text(event.title),
            ),
        ))
        .toList(),
  ),
),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Add your event"),
            content: TextFormField(
              controller: _eventController,
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("Okay"),
                onPressed: () {
                  if (_eventController.text.isNotEmpty) {
                    Event newEvent = Event(
                      id: DateTime.now().toIso8601String(),
                      title: _eventController.text,
                      date: selectedDay
                    );
                    if (selectedEvents[selectedDay] != null) {
                      selectedEvents[selectedDay]!.add(newEvent);
                    } else {
                      selectedEvents[selectedDay] = [newEvent];
                    }
                    FirestoreService().setEvent(newEvent);
                    Navigator.pop(context);
                    _eventController.clear();
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ),
        label: const Text("Add your Event ♥"),
        icon: const Icon(Icons.add),
      ),
      
    );
  }
}