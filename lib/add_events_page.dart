import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'database/EventsOnOrders.dart';
import 'database/calendarHelper.dart';



class AddEventsUsingStreamsPage extends StatefulWidget {
  final EventModel note;

  const AddEventsUsingStreamsPage({Key key, this.note}) : super(key: key);

  @override
  _AddEventsUsingStreamsPageState createState() => _AddEventsUsingStreamsPageState();
}

class _AddEventsUsingStreamsPageState extends State<AddEventsUsingStreamsPage> {

  DateTime _eventDate;
  String _time;
  bool processing = false;

  Stream<List<QuerySnapshot>> getData(){
    Stream stream1 = FirebaseFirestore.instance
        .collection('events')
        .where('event_date', isEqualTo: _eventDate ) //, arrayContains: [_eventDate.day, _eventDate.month, _eventDate.year]
        .snapshots();
    Stream stream2 = FirebaseFirestore.instance
        .collection('events').where('selected_time', isEqualTo: _time)
        .snapshots();
    return StreamZip([stream1 , stream2]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
            children: [
              hourMinute30Interval(),
              ListTile(
                title: Text(
                    '${_eventDate.year} - ${_eventDate.month} - ${_eventDate
                        .day}'),
                onTap: () async {
                  DateTime picked = await showDatePicker(context: context,
                    initialDate: _eventDate,
                    firstDate: DateTime(_eventDate.year - 1),
                    lastDate: DateTime(_eventDate.year + 10),);
                  if (picked != null) {
                    setState(() {
                      print('inside the setState of listTile');
                      _eventDate = picked ;
                    });
                  }
                },
              ),
                  SizedBox(height: 15.0,),
                  ListTile(
                    title: Text('Select a time and date for your appointment !'),
                  ),
                  StreamBuilder(
                      stream: getData(),
                      // ignore: missing_return
                      builder: (BuildContext context , AsyncSnapshot<List<QuerySnapshot>> snapshot1){
                      List<QuerySnapshot> querySnapshotData =  snapshot1.data.toList();
                      querySnapshotData[0].docs.addAll(querySnapshotData[1].docs);
                      if(querySnapshotData[0].docs.length == 0){
                        processing
                            ? Center(child: CircularProgressIndicator())
                            : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Theme
                                .of(context)
                                .primaryColor,
                            child: MaterialButton(
                                child: Text('SAVE', style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                                onPressed: () async {
                                  if (_eventDate != null) {
                                    final data = {
// "title": _title.text,
                                      'selected_time': this._time,
                                      "event_date": this._eventDate,
                                    };
                                    if (widget.note != null) {
                                      await eventDBS.updateData(
                                          widget.note.id, data);
                                    } else {
                                      await eventDBS.create(data);
                                    }
                                    Navigator.pop(context);
                                    setState(() {
                                      processing = false;
                                    });
                                  }
                                }
                            ),
                          ),
                        );
                      } else {
                        return showAlertDialogue(context);
                      }
                      }
                  ),
      ]
              ),
    );
  }
  Widget hourMinute30Interval() {
    return TimePickerSpinner(
      spacing: 30,
      minutesInterval: 30,
      onTimeChange: (time){
        setState(() {
          _time = '${time.hour} ' ;
        });
      },
    );
  }


  showAlertDialogue(BuildContext context) {

    Widget okButton = FlatButton(onPressed: (){
      Navigator.pop(context);
    }, child: Text(' OK! '));

    AlertDialog alert = AlertDialog(
      title: Text('Slot unavailable'),
      content: Text('This slot is already booked please select another slot'),
      actions: [
        okButton,
      ],
    );

    showDialog(context: context ,
        builder: (BuildContext context){
          return alert ;
        }
    );
  }

}
