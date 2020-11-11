import 'dart:async';
import 'package:http/http.dart' as http;

class ApiRequest {
   String _cityUrl = "http://airlabs.co/api/v6";
   String _cityKey = "YOUR_API_KEY_HERE";

  
  Future<http.Response> fetchCountries() async{
    return await http.get("$_cityUrl/cities?api_key=$_cityKey");
  }
}

  
 
