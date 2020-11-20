import 'package:crud_firebase/database/calendarHelper.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'add_enents.dart';
import 'database/EventsOnOrders.dart';
import 'database/calendarHelper.dart';

class datePicker extends StatefulWidget {
  @override
  _datePickerState createState() => _datePickerState();
}

class _datePickerState extends State<datePicker> {

  CalendarController calendarController;
  Map<DateTime, List<dynamic>> events;
  List<dynamic> _selectedEvents;
  DateTime eventDate;
  Duration duration;
  



  @override
  void initState() {
    super.initState();
    calendarController = CalendarController();
    events = {};
    _selectedEvents = [];
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = DateTime(
          event.eventDate.year, event.eventDate.month, event.eventDate.day , 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: StreamBuilder<List<EventModel>>(
        stream: eventDBS.streamList(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            List<EventModel> allEvents = snapshot.data;
            if(allEvents.isNotEmpty){
              events = _groupEvents(allEvents);
            }else{
              events = {};
              _selectedEvents = [];
            }
          }
          return SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TableCalendar(
                  events: events,
                  initialCalendarFormat: CalendarFormat.twoWeeks,
                  calendarController: calendarController,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    todayColor: Colors.blue,
                    selectedColor: Colors.deepOrange,
                    todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onDaySelected:  (DateTime date, events , _){
                    setState(() {
                      print('$date');
                      _selectedEvents = events;
                    });
                  },
                  builders:  CalendarBuilders(
                    selectedDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                    todayDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),..._selectedEvents.map((events) => ListTile(
                  title: Text('From $duration is booked ')
                ))
              ],
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
    onPressed: () { Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEventPage()),); }
    ),
    );
  }
}

