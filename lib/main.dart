import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flight/Data/TripDataProvider.dart';
import 'Screens/Init_Screen/InitScreen.dart';

/*
  to initiate  a provider as a global instance
  we wrap it in ChangeNtifierProvider
  otherwise when moving from screen A to screen B itll become null
*/
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
    create: (context) => TripDataProvider(),
    child:  MaterialApp(
    title: 'Flight scanner',
    debugShowCheckedModeBanner: false,
    home: InitScreen()
     ) ,
    );
  }
}



