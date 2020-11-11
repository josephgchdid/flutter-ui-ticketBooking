import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flight/Classes/Globals.dart';
import 'package:flight/Data/TripDataProvider.dart';

class DatePicker extends StatefulWidget {
  final String text;
  final bool isIgnorable;
  final Widget route;
  DatePicker({
    Key key, 
   @required this.text, 
   @required this.route, 
    this.isIgnorable=false, 
    }) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
   return Consumer<TripDataProvider>(builder: (context, data,child){
    return IgnorePointer(
      ignoring: widget.isIgnorable ? data.isOneWay() : false,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.2,
        margin: EdgeInsets.all(10),
        child: Card(
          elevation: 10,
          shadowColor: Colors.grey,
          color:(widget.isIgnorable && data.isOneWay() ) ? Colors.grey[300] : Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget.route));
            },
            splashColor: Colors.blue.withAlpha(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.text,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
                  ),
                  SizedBox(height: 30,),
                  subTitleText(data.departureDateToString(), data.returnDateToString())
                ],
              ),
            ),
          ),
        )
      ),
     );
    },);
  }

  Widget subTitleText(String deratureDate, String returnDate) {
    if(!widget.isIgnorable) {
      //widget is departure 
      return  Text( deratureDate,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
      );
    }
    else {
     return  Text(  returnDate,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
      );
    }
  }
}

class DateDialog extends StatefulWidget {
  final String title;
  final Function onDateChanged;
  final DateTime initialDate;
  final DateTime minDate;
  final DateTime maxDate;
  DateDialog(
  {
    Key key, 
    @required this.title, 
    @required this.onDateChanged,
    @required this.initialDate,
    @required this.minDate,
    @required this.maxDate
  }
  ): super(key: key);

  @override
  _DateDialogState createState() => _DateDialogState();
}

class _DateDialogState extends State<DateDialog> {
  @override
  Widget build(BuildContext context) {
   DateTime time = widget.initialDate;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title), backgroundColor: mainColor,),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          backgroundColor: secondaryColor,
          onPressed: (){
            Function.apply(widget.onDateChanged, [time]);
            Navigator.of(context).pop();
          },
        ),
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: widget.initialDate,
        minimumDate: widget.minDate,
        maximumDate: widget.maxDate ,
        onDateTimeChanged: (date) {
          time = date;
         },
          ),
        ),
      ),
    );
  }
}