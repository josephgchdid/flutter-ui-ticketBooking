import 'package:flutter/material.dart';
import 'package:flight/Screens/Main_Screen/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:flight/Classes/Globals.dart';
import 'package:flight/Data/TripDataProvider.dart';

int selectedIndex = -1; //to get selected item from list
String city;
class ChangeCountry extends StatefulWidget {
  ChangeCountry({Key key}) : super(key: key);

  @override
  _ChangeCountryState createState() => _ChangeCountryState();
}

class _ChangeCountryState extends State<ChangeCountry> {
  TripDataProvider provider;
  TextEditingController searchController = new TextEditingController();
  List<CountryTab> countryTabList = new List<CountryTab>();
  List<CountryTab> duplicateTabItems = new List<CountryTab>(); //hold dummy data for search 
  final scaffoldKey = GlobalKey<ScaffoldState>(); 

  @override
  void initState(){
    super.initState();
    provider = Provider.of<TripDataProvider>(context, listen: false);
    buildList();
    selectedIndex = -1;
    city = "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('choose city'),
            backgroundColor: mainColor,
          ),
          key : scaffoldKey,
         floatingActionButton: FloatingActionButton(onPressed: () => onFloatingButtonPressed(context)
          ,backgroundColor: mainColor,
          child: Icon(Icons.check)
          ),
          body: Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.all(10),
           child: Column(
             children: [
               TextField(
                 onChanged: (value) => onListSearch(value),
                 controller: searchController,
                 decoration: InputDecoration(
                   labelText: "search",
                   prefixIcon: Icon(Icons.search),
                   border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))))
               ),
               Expanded(child: new ListView.builder(itemCount: countryTabList.length ,itemBuilder: (BuildContext context, index)  {
                  return countryTabList[index];
               })
               ),            
             ],
           )
        ),
     ),
   );
 }
 
 void onFloatingButtonPressed(BuildContext context) {
  if(selectedIndex == -1) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text('Please select a city')));
   }   
   else {
     provider.changeDepartureCity(city);
     provider.locationIsOn = true;
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
   }     
 }

 void buildList() {
   int index = 0;
   provider.cities().forEach((element) { 
     countryTabList.add(new CountryTab(code: element.cityCode, name: element.cityName, index: index, countryCode: element.countryCode, ));
     index++;
   });
   duplicateTabItems.addAll(countryTabList);
  }

  void onListSearch(String query) {
   if(query.isNotEmpty) {
     setState(() {
        countryTabList.clear();
        countryTabList = duplicateTabItems.where((element) =>  
         element.name.toLowerCase().contains( query.trim().toLowerCase())).toList();       
     });
      
   }else {
    setState(() {
      countryTabList.clear();
      countryTabList.addAll(duplicateTabItems);       
    });
   }
  }
}

class CountryTab extends StatefulWidget {
   final String code,name, countryCode;
   final int index;

  CountryTab({Key key, this.code, this.name, this.countryCode, this.index}) : super(key: key);

  @override
  _CountryTabState createState() => _CountryTabState();
}

class _CountryTabState extends State<CountryTab> {


  @override
  Widget build(BuildContext context) {
    return Container(
       child: GestureDetector(
      onLongPress:(){
         setState(() {
           if(selectedIndex == widget.index )
           selectedIndex = -1;
         });
      },
       onTap: (){
         setState(() {
          if(selectedIndex == -1){
             selectedIndex = widget.index;
             city = widget.name;
          }
        });
       },
       child: Container(
        width: 200 ,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.grey[100], width: 1)
        ),
        child: Row(
         children: [
          selectedIndex != widget.index ? SizedBox() : Icon(Icons.check, color: Color(0xff3c3fff),size: 20,),
          Center(child: Text("${widget.name} (${widget.code})", style:  TextStyle(fontWeight: FontWeight.bold),),),
         ],
        ),
      ),
      ),
    );
  }
}