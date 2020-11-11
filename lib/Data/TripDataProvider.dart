import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flight/Classes/City.dart';

class TripDataProvider extends ChangeNotifier {
  Set<City> _cities = new Set<City>();
  bool _isOneWay = false;
  bool _isTwoWay = true;
  DateTime _departDate;
  DateTime _returnDate;
  DateTime _maxReturnDate;
  DateTime _minReturnDate;
  City _departureCity = new  City();
  City _arrivalCity = new City();
  bool locationIsOn = false;
  int _totalAdults = 1;
  int _totalInfants = 0;
  int _totalChildren = 0;
  int _maxPeople = 9;
  //
  TripDataProvider() {
    changeDepartureDate(DateTime.now());
    changeReturnDate(_minReturnDate);
    _arrivalCity.cityName = "";
    _arrivalCity.cityCode = "";
    _arrivalCity.countryCode = "";
  }

  void oneWayTrip() {
    _isOneWay = true;
    _isTwoWay = false;
    notifyListeners();
  }

  void twoWayTrip() {
    _isTwoWay  = true;
    _isOneWay = false;
    notifyListeners();
  }
  
  bool isOneWay() {
    return _isOneWay;
  }

  bool isTwoWay() {
    return _isTwoWay;
  }

  DateTime maxReturnDate() {
    return _maxReturnDate;
  }

  DateTime minReturnDate() {
    return _minReturnDate;
  }

  DateTime minDepartureDate(){
    return _departDate;
  }
  
  DateTime maxDepartureDate() {
    return new DateTime(_departDate.year + 1, _departDate.month, _departDate.day);
  }

  void changeDepartureDate(DateTime time) {
    //could add one day to minReturn, but maybe user wants same day flight
    _minReturnDate = new DateTime(time.year, time.month, time.day +1);
    _maxReturnDate = new DateTime(time.year + 1, time.month, time.day );
    _departDate = new DateTime(time.year, time.month, time.day);
    // on init returnDate might be null, glue fix
    if(_returnDate != null) {
      if(_returnDate.isBefore(_departDate)) {
       _returnDate = new DateTime(_departDate.year, _departDate.month, _departDate.day );
     }
    }
    notifyListeners();
  }

  String departureDateToString() {
    String month = _departDate.month < 10 ? "0${_departDate.month}" : "${_departDate.month}";
    String day = _departDate.day < 10 ? "0${_departDate.day}" : "${_departDate.day}";
    return "$day-$month-${_departDate.year}";
  }

  void changeReturnDate(DateTime time) {
    _returnDate = new DateTime(time.year, time.month, time.day);
    notifyListeners();
  }

  String returnDateToString() {
      String month = _returnDate.month < 10 ? "0${_returnDate.month}" : "${_returnDate.month}";
    String day = _returnDate.day < 10 ? "0${_returnDate.day}" : "${_returnDate.day}";
    return "$day-$month-${_departDate.year}";
  }

  String departureCity() {
    return _departureCity.cityName;
  }

  String departureCityCode() {
    return _departureCity.cityCode;
  }

  void initDepartureCity(String countryCode){
      var element = _cities.where((element) => element.countryCode.toLowerCase() == countryCode.toLowerCase()).first;
      this._departureCity = element;
      notifyListeners();
  }

  void changeDepartureCity(String code) {
      var element = _cities.where((element) => element.cityCode.toLowerCase() == code.toLowerCase()).first;
      this._departureCity = element;
      notifyListeners();
  }

  String arrivalCity() {
    return _arrivalCity.cityName;
  }

  String arrivalCityCode() {
    return _arrivalCity.cityCode;
  }

  void changeReturnCity(String code) {
     if(_departureCity.cityCode != code) {
         var element = _cities.where((element) => element.cityCode.toLowerCase() == code.toLowerCase()).first;
         this._arrivalCity = element;
        notifyListeners();
     }

  }

    void addCity(City city) {
      _cities.add(city);
    }

    List<City> cities() {
      return _cities.toList();
    }

    int totalAdults() {
      return _totalAdults;
    }

    void incrementAdultCount() {
      _totalAdults++;
      if(_totalAdults > _maxPeople) 
        _totalAdults = _maxPeople;
      notifyListeners();
    } 

    void decrementAdultCount() {
      _totalAdults--;
      if(_totalAdults <= 0)
        _totalAdults = 1;
      notifyListeners();
    }

    int totalInfants() {
      return _totalInfants;
    }

    void  incrementInfantCount() {
       _totalInfants++;
      if(_totalInfants > _maxPeople) 
        _totalInfants = _maxPeople;
      notifyListeners();
    }

    void decrementInfantCount(){
      _totalInfants--;
      if(_totalInfants < 0)
        _totalInfants = 0;
      notifyListeners();
    }

    int totalChildren() {
      return _totalChildren;
    }

    void incrementChildrenCount() {
      _totalChildren++;
      if(_totalChildren > _maxPeople) 
        _totalChildren = _maxPeople;
      notifyListeners();
    }

    void decrementChildrenCount() {
      _totalChildren--;
      if(_totalChildren < 0 ) 
        _totalChildren = 0;
      notifyListeners();
    }
}