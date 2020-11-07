import 'package:flutter/material.dart';
import 'database/EventsOnOrders.dart';
import 'database/calendarHelper.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddEventPage extends StatefulWidget {
  final EventModel note;

  const AddEventPage({Key key, this.note}) : super(key: key);
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {

  DateTime _eventDate;
  bool processing;
  String _time;
  String selectedTime;


  @override
  void initState() {
    super.initState();
    _eventDate = DateTime.now();
    processing = false ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Please select a date'),),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}'),
              onTap: () async {
                DateTime picked = await showDatePicker(context: context,
                    initialDate: _eventDate,
                    firstDate: DateTime(_eventDate.year - 1),
                  lastDate:  DateTime(_eventDate.year + 10),);
                if(picked != null){
                  setState(() {
                    print('inside the setState of listTile');
                    _eventDate = picked;
                  });
                }
              },
            ),
            SizedBox(height: 10.0 ),
            ListTile(
              title: Text('Select time for appointment!'),
              onTap: () async {
                DatePicker.showTimePicker(context,
                    theme: DatePickerTheme(
                      containerHeight: 210.0,
                    ),
                    showTitleActions: true, onConfirm: (time) {
                      print('confirm $time');
                      _time = '${time.hour} : ${time.minute} : ${time.second}';
                      setState(() {
                        selectedTime = _time ;
                      });
                    }, currentTime: DateTime.now() , locale: LocaleType.en);
              },
            ),
            processing
                ? Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Theme.of(context).primaryColor,
                child: MaterialButton(
                  onPressed: () async {
                    if (_eventDate != null) {
                      setState(() {
                        print('inside the setState of the material button');
                        processing = true;
                      });
                      final data = {
                        // "title": _title.text,
                        'selected_time ' : this.selectedTime,
                        "event_date": this._eventDate
                      };
                      if (widget.note != null) {
                        await eventDBS.updateData(widget.note.id, data);
                      } else {
                        await eventDBS.create(data);
                      }
                      Navigator.pop(context);
                      setState(() {
                        processing = false;
                      });
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
