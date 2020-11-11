import 'package:flutter/material.dart';
import 'package:flight/Classes/Globals.dart';
import 'package:provider/provider.dart';
import 'package:flight/Data/TripDataProvider.dart';
import 'package:flight/Widgets/TripTypeButton.dart';

class TabViewHeader extends StatefulWidget {
  final String title;
  final String subTitle;
  final Icon icon;
  TabViewHeader(
    {
      Key key, 
      this.title, 
      this.subTitle,
      this.icon
    }
    ): super(key: key);

  @override
  _TabViewHeaderState createState() => _TabViewHeaderState();
}

class _TabViewHeaderState extends State<TabViewHeader> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(widget.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Text(widget.subTitle),
        ),
        Consumer<TripDataProvider>(builder: (context, tripProvider,child){
         Color oneWaycolor = tripProvider.isOneWay() ? mainColor : secondaryColor;
         Color twoWaycolor = tripProvider.isOneWay() ? secondaryColor :  mainColor;
         return  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TripTypeButton(
              btnText: "One way trip",
              color: oneWaycolor, 
              onPress: () => tripProvider.oneWayTrip()
              ,),
            Padding(padding: EdgeInsets.all(10)),
            TripTypeButton(
              btnText: "Two way trip",
              color: twoWaycolor,
              onPress: () => tripProvider.twoWayTrip() ,
              )
            ],
          );
        }),
      ],
    );
  }
}