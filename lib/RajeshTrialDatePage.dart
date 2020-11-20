import 'package:cloud_firestore/cloud_firestore.dart';

class AddingEventsUsingRajeshMethod {
  getAvailableSlots(String _eventDate , String _time){
    return FirebaseFirestore.instance
        .collection('events')
        .where('event_date', isEqualTo: _eventDate )
        .where('selected_time', isEqualTo: _time)
        .get();
  }
}