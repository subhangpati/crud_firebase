import 'package:crud_firebase/DatePage.dart';
import 'package:flutter/material.dart';
import 'DatePage.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  // String selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pick a date'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('SELECT DAY'),
                color: Color(0xFFF8E170),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => datePicker()),
            );
          }),
              // RaisedButton(
              //     child: Text('SELECT TIME'),
              //     color: Color(0xFFF8E170),
              //     onPressed: () {
              //         DatePicker.showTimePicker(context,
              //             theme: DatePickerTheme(
              //               containerHeight: 210.0,
              //             ),
              //             showTitleActions: true, onConfirm: (time) {
              //               print('confirm $time');
              //               _time = '${time.hour} : ${time.minute} : ${time.second}';
              //               setState(() {
              //                selectedTime = _time ;
              //               });
              //             }, currentTime: DateTime.now() , locale: LocaleType.en);
              //         setState(() async {
              //           final data = {
              //             'selected_time ' : widget.note.selectedTime,
              //           };if(widget.note != null) {
              //             await eventDBS.updateData(widget.note.id, data);
              //           } else {
              //             await eventDBS.create(data);
              //           }
              //         });
              //       },
              //       ),
            ],
          ),
        ),
      ),
    );
  }
}
