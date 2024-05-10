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
            focusedDay: focusedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
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
                color: Color(0xFFFECCA5), // Peachy Rose for selected day
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Color(0xFFFD6842), // Marigold for today
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                color: Color(0xFFC1DFE3), // Clear Skies for weekends
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
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
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFFCF4EA), // Seashell for event container
                            border: Border.all(color: Color(0xFF548749)), // English Ivy for border
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(event.title, style: TextStyle(color: Color(0xFF548749))), // English Ivy for text
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
        backgroundColor: Color(0xFFBAB759), // Olive Green for FAB
      ),
    );
  }
}
