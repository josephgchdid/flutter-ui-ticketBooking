class City {
  String cityCode;
  String cityName;
  String countryCode;

  City({this.cityCode, this.cityName, this.countryCode});

  City.fromMap(Map<String,dynamic> map) {
    cityCode = map['code'];
    cityName = map['name'];
    countryCode = map['country_code'];
  }
}