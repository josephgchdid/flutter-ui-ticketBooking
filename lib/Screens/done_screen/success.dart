import 'package:flutter/material.dart';
import 'package:flight/Classes/Globals.dart';

class Success extends StatelessWidget {
  
  const Success({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return SafeArea(
      child: Scaffold(
        body:Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      width: double.infinity,
      height: double.infinity,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text('Success! do you want to book another ticket ?',
        textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 15,),
        )),
      SizedBox(height:20),
     ButtonTheme(
       minWidth: 200,
       height: 50,
       child:   FlatButton(child: Icon(Icons.home, color: Colors.white,),
       color: mainColor,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(15),
       ),
       onPressed: () {
          Navigator.of(context).pop();
           }),
          )
         ],
        ),
       ) ,
      ),
    );
  }
}