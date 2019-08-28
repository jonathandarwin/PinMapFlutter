import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationUtil{
  static Future<LatLng> getCurrentPosition() async {
    Location location = Location();
    Map<String, double> loc = await location.getLocation();
    return LatLng(loc['latitude'], loc['longitude']);    
  }

  static Future<List<Address>> getPositionDescription(LatLng position) async {
    Coordinates coor = Coordinates(position.latitude, position.longitude);
    List<Address> _listAddress = await Geocoder.local.findAddressesFromCoordinates(coor);
    return _listAddress;
  }

  static Future<List<Address>> getAddressByDescription(String desc) async {
    List<Address> _listAddress = await Geocoder.local.findAddressesFromQuery(desc);
    return _listAddress;
  }
}