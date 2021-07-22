import 'dart:developer';

import 'package:location/location.dart';
import 'package:al_wahab/controller/shared_preferences.dart';

import 'constant.dart';

Location location =  Location();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
Future<void> getPermissionOfLocation()async{
  LocationData _locationData;
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }

  }
  _locationData = await location.getLocation();

}

getLocationOnLocationChanged(){
  location.onLocationChanged.listen((LocationData currentLocation) {
    Constants.lat = currentLocation.latitude.toDouble();
    Constants.long = currentLocation.longitude.toDouble();
    Constants.timeZone=(currentLocation.longitude.toDouble()/15.0).toDouble();
    saveLatLongAndTimeZone(
        latitude: Constants.lat,
        longitude: Constants.long,
        TimeZone: Constants.timeZone
    );
    log("currentLocation.latitude.toDouble() is ${currentLocation.latitude.toDouble()}");

  });
}