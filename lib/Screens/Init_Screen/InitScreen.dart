import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flight/Classes/City.dart';
import 'package:flight/Classes/Globals.dart';
import 'package:flight/Data/LocalData.dart';
import 'package:flight/Data/TripDataProvider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flight/Data/ApiRequest.dart';
import 'package:flight/Screens/Main_Screen/HomePage.dart';
import 'package:flight/Screens/change_city/ChangeCity.dart';


bool countryIsSelected = false;
class InitScreen extends StatefulWidget {
  InitScreen({Key key}) : super(key: key);

  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState   extends State<InitScreen> {
  TripDataProvider provider;
  ApiRequest _request = new ApiRequest();
 

  Future<void> getResidentCountryName() async {  
      if(await Permission.location.isUndetermined) {
          provider.locationIsOn = await Permission.location.request().isGranted; // default is false
      }
      else 
          provider.locationIsOn = await Permission.location.isGranted; 
     
      if(provider.locationIsOn) {
        Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        final coordinates = new Coordinates(position.latitude, position.longitude);
        var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        provider.initDepartureCity(address.first.countryCode);
      }
  }

  Future<void> initData() async {
  LocalData database = new LocalData();//sqlite 
   var queryResult = await database.getRecords();
   
    if(queryResult.isEmpty || queryResult == null) {  
      //first time a user initializes the app
      var response =  await _request.fetchCountries();
      Map<String,dynamic> json = jsonDecode(response.body);
        for(var values in json['response']) {
          provider.addCity(City.fromMap(values));
        }
       await database.insertBatch(provider.cities());
    }
    else { 
      //user already used the app once , so sqlite is already populated
      queryResult.forEach((element) {
        provider.addCity(new City.fromMap(element));
      });
    }
  }

  Future<void> onStart(BuildContext context) async {
    await getResidentCountryName();
    provider.locationIsOn ? 
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage())) :
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChangeCityPormpt()));
  }
  
  @override 
  void initState() { 
    super.initState();
    provider = Provider.of<TripDataProvider>(context, listen: false);
     (() async {
       print("initing");
        await initData();
     })();
    onStart(context);
  }

  @override 
  void dispose() {     
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
    child:  Scaffold(
          body: FutureBuilder<void>(
          future: onStart(context),
          builder: (BuildContext context, AsyncSnapshot<void>  snapshot){
            if(snapshot.connectionState != ConnectionState.done) {
              return Center(child:Text('processing'));
            }
            return  Center(child:Text('processing'));
          },
        ),
      )
    ); 
  }
}

  //if user clicked dont allow for location ,send them
  // to a page to manually input country

class ChangeCityPormpt extends StatelessWidget {
  const ChangeCityPormpt({Key key}) : super(key: key);

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
        Center(child: Text('You did not allow location\nEither allow location\nOr manually select a country',
        textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 15,),
        )),
      SizedBox(height:20),
     ButtonTheme(
       minWidth: 200,
       height: 50,
       child:   FlatButton(child: Icon(Icons.add_location, color: Colors.white,),
       color: mainColor,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(15),
       ),
       onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangeCountry()));
      }),
        )
      ],
        ),
       ) ,
      ),
    );
  }
}

// 