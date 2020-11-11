import 'package:flight/Classes/Globals.dart';
import 'package:flutter/material.dart';
import 'package:flight/Screens/Main_Screen/BrowseDatesView.dart';



class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double width;
  double height = 100;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search flight"),
          backgroundColor: mainColor,
        ),
        body:  BrowseDatesView(),
        )
    );
  }
}