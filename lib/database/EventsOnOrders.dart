import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:intl/intl.dart';

class EventModel extends DatabaseItem{
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String selectedTime ;

  EventModel({this.id,this.title, this.description, this.eventDate , this.selectedTime}):super(id);

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      description: data['description'],
      eventDate: DateFormat('dd/MM/yyyy', 'en_US').parse(data['event_date']),
        selectedTime : data['selected_time']
    );
  }

  factory EventModel.fromDS(String id, Map<String,dynamic> data) {
    return EventModel(
      id: id,
      title: data['title'],
      description: data['description'],
      eventDate:  DateFormat('dd/MM/yyyy', 'en_US').parse(data['event_date']),
        selectedTime: data['selected_time']
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "title":title,
      "description": description,
      "event_date": DateFormat('dd/MM/yyyy', 'en_US').parse('event_date'),
      "id":id,
      "selected_time": selectedTime
    };
  }
}