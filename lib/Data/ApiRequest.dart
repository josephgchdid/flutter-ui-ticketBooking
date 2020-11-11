import 'dart:async';
import 'package:http/http.dart' as http;

class ApiRequest {
   String _cityUrl = "http://airlabs.co/api/v6";
   String _cityKey = "738a2cac-6d56-489d-bdc1-5eaf0be0f80b";

  
  Future<http.Response> fetchCountries() async{
    return await http.get("$_cityUrl/cities?api_key=$_cityKey");
  }
}

  
 