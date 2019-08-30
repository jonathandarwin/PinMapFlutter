import 'dart:async';

import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pin_map/base/base_provider.dart';
import 'package:pin_map/model/place.dart';
import 'package:pin_map/repository/place_repository.dart';
import 'package:pin_map/state/event_state.dart';
import 'package:pin_map/util/location_util.dart';

class HomeProvider extends BaseProvider{
  // Repository
  PlaceRepository _placeRepository = PlaceRepository();

  // Attribute
  Set<Marker> _listMarker = Set<Marker>();
  LatLng _lastPosition;
  LatLng _focus;
  List<Place> _listPlace = List<Place>();
  GoogleMapController _controller;

  // Getter
  Set<Marker> get listMarker => this._listMarker;
  LatLng get focus => this._focus;
  List<Place> get listPlace => this._listPlace;
  GoogleMapController get controller => this._controller;

  // Setter
  set listMarker(Set<Marker> listMarker) => this._listMarker = listMarker;      
  set focus(LatLng focus){
    this._focus = focus;    
  }
  set listPlace(List<Place> listPlace) => this._listPlace = listPlace;
  set controller(GoogleMapController controller) => this._controller = controller;

  Future<int> requestInitData() async {
    try{
      if(await requestFocus() == EventState.SUCCESS && await requestListPlace() == EventState.SUCCESS){
        return EventState.SUCCESS;
      }
    }
    on Exception{
      print('<ERR> Error while loading data.');
    } 
    return EventState.ERROR;
  }

  Future<int> requestFocus() async {
    try{
      Place place = await getCurrentLocation();
      LatLng currentPosition = LatLng(place.lat, place.lang);
      focus = currentPosition;
      return EventState.SUCCESS;
    }
    on Exception{
      print('<ERR> Error while loading data.');
      return EventState.ERROR;
    }
  }

  Future<int> requestListPlace() async {
    try{
      listPlace.clear();      
      Place currentPlace = await getCurrentLocation();
      listPlace.add(currentPlace);
      listPlace.addAll(await _placeRepository.requestListPlace());

      listMarker.clear();
      for(Place place in listPlace){
        LatLng latLng = LatLng(place.lat, place.lang);
        listMarker.add(
          Marker(
            markerId: MarkerId(place.id.toString()),          
            position: latLng,
            infoWindow: InfoWindow(
              title: place.description
            ),
            icon: BitmapDescriptor.defaultMarker
          )
        );
      }      
      return EventState.SUCCESS;
    }
    on Exception{
      print('<ERR> Error while loading data.');
    } 
    return EventState.ERROR;   
  }

  void cameraMove(CameraPosition cameraPosition){
    _lastPosition = cameraPosition.target;
  }

  Future<Place> getCurrentLocation() async {
    LatLng position = await LocationUtil.getCurrentPosition();
    List<Address> listAddress = await LocationUtil.getPositionDescription(position);
    Place place = Place.seData(0, listAddress.first.addressLine, "Your Location", position.latitude, position.longitude);
    return place;
  }

  Future<bool> deletePlace(Place place) async {
    if(await _placeRepository.deletePlace(place) >= 1)
      return true;    
    return false;
  }
}