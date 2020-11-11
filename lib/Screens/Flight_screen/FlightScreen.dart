import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flight/Classes/Globals.dart';
import 'package:flight/Data/TripDataProvider.dart';
import 'package:flight/Screens/done_screen/success.dart';
import 'package:provider/provider.dart';


class FlightScreen extends StatefulWidget {
  FlightScreen({Key key}) : super(key: key);

  @override
  _FlightScreenState createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  TripDataProvider tripDataProvider;
 
  @override
  void initState() {
    super.initState();
    tripDataProvider = Provider.of<TripDataProvider>(context, listen: false);   
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text("Flights"),
          shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.only(
             bottomLeft:  Radius.circular(40),
          ),
          ),
          bottom: PreferredSize(
            preferredSize: Size( MediaQuery.of(context).size.width ,MediaQuery.of(context).size.height * 0.15),
            child:tripData(),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.only(top:10, right: 10,bottom: 10),
          color: Colors.white,
          child: tripDataProvider.isTwoWay() ? 
            ListView.builder(itemCount: 10, itemBuilder: (context, index){
            return twoWayTripCard(context);
          }) :
          ListView.builder(itemCount: 10, itemBuilder: (context, index){
            return oneWayTripCard(context);
          })
        ),
      ),
    );
  }
  
  Widget tripData() {
    TextStyle top = TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20);
    TextStyle bottom = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15);
    return Padding(
      padding: const EdgeInsets.only(left:30, bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
            Column(
            children: [
              Text("${tripDataProvider.departureCity()}", style: top,),
              Text("(${tripDataProvider.departureCityCode()})", style: bottom,),
             ],
             ),
              SizedBox(width: 30,),
              Transform.rotate(
                angle: pi / 2,
                child: Icon(Icons.airplanemode_active, color: Colors.white),
              ),
              SizedBox(width: 30,),
              Column(
              children: [
                Text("${tripDataProvider.arrivalCity()}", style: top,),
                Text("(${tripDataProvider.arrivalCityCode()})", style: bottom,),
              ],
             ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Text("${tripDataProvider.departureDateToString()}", style: bottom,),
              SizedBox(width: 30,),
              SizedBox(width: 20,),
              tripDataProvider.isOneWay() ?
               Text(""):
               Text("${tripDataProvider.returnDateToString()}", style: bottom,),

            ],
          )
        ],
      ),
    );
  }

  TextStyle style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  TextStyle smallStyle = TextStyle(fontWeight: FontWeight.w400, color: Colors.grey);
  
  Widget twoWayTripCard(BuildContext context) {
   return Container(
      width: MediaQuery.of(context).size.width * 0.8 ,
      height:  MediaQuery.of(context).size.width * 0.7,
      margin: EdgeInsets.only(top: 20),
      child: Card(
      shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight:  Radius.circular(40),
        ),
      ),
      elevation: 5,
       child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
           children: <Widget>[ 
             dataCard(context,tripDataProvider.departureCityCode(),tripDataProvider.arrivalCityCode()),
             SizedBox(height: 20,),
             dataCard(context,tripDataProvider.arrivalCityCode(),tripDataProvider.departureCityCode()),
             SizedBox(height: 20,),
             selectButton(context)
           ]
         ),
        ),
      )                
   );
  }

  Widget oneWayTripCard(BuildContext context) {
 return Container(
      width: MediaQuery.of(context).size.width * 0.8 ,
      height: 150,
      margin: EdgeInsets.only(top: 20),
      child: Card(
      shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight:  Radius.circular(40),
        ),
      ),
      elevation: 5,
       child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
           children: <Widget>[ 
             dataCard(context,tripDataProvider.departureCityCode(),tripDataProvider.arrivalCityCode()),
             SizedBox(height: 20,),
             selectButton(context)
           ]
         ),
        ),
      )                
   );
  }

  Widget dataCard(BuildContext context, String departure, String arrival) {
    return  Row( 
      children: [
        Column(
          children: [
             Text("04:15",style: style,),
             Text(departure, style: smallStyle,)
          ],
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.2,),
        Text("6h 10min", style: smallStyle,),
        SizedBox(width: MediaQuery.of(context).size.width * 0.2,),
        Column(
          children: [
            Text("10:25",style: style,),
            Text(arrival, style: smallStyle,)
          ],
        ),
      ],
    );
  }

  Widget selectButton(BuildContext context) {
    Random random = new Random();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("${random.nextInt(900) + 200} \$", style: style,),
        SizedBox(width: 10,),
        ButtonTheme(
         minWidth: 25,
         height: 45,
         child:   FlatButton(
          child: Text("Select",
          style: TextStyle(color: Colors.white, fontSize: 18)
          ),
         color: mainColor,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(15),
         ),
         onPressed: () => Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (context) => Success())
         )
        ),
       ),
       Padding(padding: EdgeInsets.only(left: 30))
      ],
    );
  }
}

