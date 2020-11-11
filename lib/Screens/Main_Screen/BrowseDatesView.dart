import 'package:flutter/material.dart';
import 'package:flight/Screens/Flight_screen/FlightScreen.dart';
import 'package:provider/provider.dart';     
import 'package:flight/Classes/Globals.dart';
import 'package:flight/Data/ApiRequest.dart';
import 'package:flight/Widgets/DatePicker.dart';
import 'package:flight/Data/TripDataProvider.dart';
import 'package:flight/Widgets/TabViewHeader.dart';

class BrowseDatesView extends StatefulWidget {
  BrowseDatesView({Key key}) : super(key: key);

  @override
  _BrowseDatesTabViewState createState() => _BrowseDatesTabViewState();
}

class _BrowseDatesTabViewState extends State<BrowseDatesView> {
  ApiRequest request = new ApiRequest();
  TripDataProvider tripProvider;
  DateTime today;
  @override
  void initState() {
    super.initState();
    tripProvider = Provider.of<TripDataProvider>(context, listen: false);
    today = tripProvider.minDepartureDate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
     children: [
        Container(
          padding: EdgeInsets.all(15),
          child: TabViewHeader(
            icon:  Icon(Icons.flight_land),
            title: "Browse Flight",
            subTitle: "View Flights by date",
          ),
        ),
        SizedBox(height: 30),
        Consumer<TripDataProvider>(builder: (context, data,child){
          return Expanded(
           child: ListView(
               children: [
                 selectAirports(context),
                 SizedBox(height:20),
                 DatePicker(
                   text: "Departure date",
                  route: DateDialog(
                   title: "Select departure date" ,
                   onDateChanged: tripProvider.changeDepartureDate,
                   initialDate: tripProvider.minDepartureDate(),
                   minDate:  today,
                   maxDate: tripProvider.maxDepartureDate(),
                    ),
                  ),
                 DatePicker(
                   text: "Return date", 
                   isIgnorable: true,
                  route: DateDialog(
                    title: "Select return date",
                    onDateChanged:  tripProvider.changeReturnDate,
                    initialDate: tripProvider.minReturnDate(),
                    minDate: tripProvider.minReturnDate(),
                    maxDate: tripProvider.maxReturnDate(),
                  ),
                 ),
                 //
                 SizedBox(height: 30,),
                 personCounter("Number of infants : ", tripProvider.totalInfants(),
                  tripProvider.incrementInfantCount, tripProvider.decrementInfantCount),
                  //
                  SizedBox(height: 30,),
                 personCounter("Number of children (2 - 12 years) : ", tripProvider.totalChildren(),
                 //
                  tripProvider.incrementChildrenCount, tripProvider.decrementChildrenCount),
                 SizedBox(height: 30,),
                 personCounter("Number of adults (12 years and up) : ", tripProvider.totalAdults(),
                  tripProvider.incrementAdultCount, tripProvider.decrementAdultCount),
                  SizedBox(height: 10),
                 searchButton(context),
             ],
           ),
         );
       }
     )],
    );
  }

  Widget selectAirports(BuildContext context) {
    TextStyle  style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
    return Container(
      width: double.infinity,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Consumer<TripDataProvider>(builder: (context, data ,child){
           return  GestureDetector(
            onTap: () => showAirportPopup(context, tripProvider.changeDepartureCity),
            child: ListTile(
              leading: Icon(Icons.flight_takeoff),
              title: Text("From "),
              subtitle: Text("${tripProvider.departureCity()} (${tripProvider.departureCityCode()})", 
              style: style,),
            ),
          );
         },),
         CustomPaint(
           painter: LinePainter(),
           child: Container(
             width: 10,
             height: 10,
           ),
         ),
         SizedBox(height:30),
           Consumer<TripDataProvider>(builder: (context, data ,child){
           return  GestureDetector(
            onTap: () => showAirportPopup(context, tripProvider.changeReturnCity),
            child: ListTile(
              leading: Icon(Icons.flight_land),
              title: Text("To"),
              subtitle: tripProvider.arrivalCity().isNotEmpty ?
               Text("${tripProvider.arrivalCity()} (${tripProvider.arrivalCityCode()})", style: style,) :
               Text("Please select a City", style: style,)                
            ),
          );
         },),
        ],
      ),
    ); 
  }

  Widget searchButton(BuildContext context) {
  return  Container(
      margin: EdgeInsets.all(30),
      child: ButtonTheme(
         minWidth: 5,
         height: 50,
         child:   FlatButton(
          child: Text("search",
          style: TextStyle(color: Colors.white, fontSize: 18)
          ),
         color: mainColor,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(15),
         ),
         onPressed: () => onSearch(context)
        ),
      ),
   );
  }

  void onSearch(BuildContext context) async {
    if(tripProvider.arrivalCity().isEmpty) {
      await alertUser(context);
    }
    else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => FlightScreen()));
    }
  }

  void showAirportPopup(BuildContext context, Function callback) async {
  List<Widget> modalSheetCityList = new List<Widget>();
  TextEditingController searchController = new TextEditingController();
   await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      context:  context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, updateState) {
             return Container(
            padding: EdgeInsets.all(20),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:  BorderRadius.only(
             topRight: Radius.circular(20),
             topLeft: Radius.circular(20)
            ),
           ),
           child: Column(
             children: [
              Center(
                child: Text("Please select a City", style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 15,),
              TextField(
                onChanged: (query) {
                  if(query.isNotEmpty) {
                    var cityList  = tripProvider.cities().where((element) =>  element.cityName.toLowerCase().contains( query.trim().toLowerCase()));
                    updateState(() {
                    modalSheetCityList.clear();
                    cityList.forEach((element) { modalSheetCityList.add(modalItem(element.cityName, element.cityCode,callback, context)); });
                  });
                }
                else {
                updateState(() { modalSheetCityList.clear(); });
                  }                   
                },
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))))
              ),
              Expanded(
                child: ListView.builder(itemCount: modalSheetCityList.length, itemBuilder: (context,index) {
                  return modalSheetCityList[index];
                }),
              )
             ],
           ),
          );
        }); 
      }
    );
  }

  Widget modalItem(String title,String code, Function callback, BuildContext context) {
    return GestureDetector(
    onTap: () {
      Function.apply(callback, <dynamic>[code]);
      Navigator.of(context).pop();
    } ,
     child: Container(
        width: double.infinity,
        height: 100,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.grey,width: 1)
        ),
        child: Center(
          child: Text("$title ($code)")
        ,),
      ),
    );
  }

  Widget personCounter(String title, int counter, Function onIncrement, Function onDecrement) {
    return Container(
      height: 120,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
             ),
             Consumer<TripDataProvider>(builder: (context, data, child){
               return  Text("$counter",
                  style: TextStyle(fontSize: 20),
                );
             }),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               MaterialButton(
                color: secondaryColor,
                child: Icon(Icons.add, size: 24, color: Colors.white),
                onPressed: (){
                  onIncrement();
                },
                padding: EdgeInsets.all(20),
                shape: CircleBorder(),
              ),  
               MaterialButton(
                color: secondaryColor,
                child: Icon(Icons.remove, size: 24, color: Colors.white),
                onPressed: (){
                  onDecrement();
                },
                padding: EdgeInsets.all(20),
                shape: CircleBorder(),
             ),
            ],
          )
        ],
      ),
    );
  }

  Future alertUser(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
         content: Text("Please select an arrival city"),
        );
      }
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Offset p1 = new Offset(30, -20);
    Offset p2 = new Offset(30, 50);
    Paint paint = new Paint();
    paint.color = Colors.grey; 
    paint.strokeWidth = 2;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint( CustomPainter oldDelegate) {
    return false;
  }
}