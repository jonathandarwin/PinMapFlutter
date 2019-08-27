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

  // Getter
  Set<Marker> get listMarker => this._listMarker;
  LatLng get focus => this._focus;

  // Setter
  set listMarker(Set<Marker> listMarker) => this._listMarker = listMarker;      
  set focus(LatLng focus) => this._focus = focus;

  Future<int> requestListPlace() async {
    try{
      List<Place> listPlace = await _placeRepository.requestListPlace();
      Place currentPlace = await getCurrentLocation();
      listPlace.add(currentPlace);

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
      
      focus = LatLng(currentPlace.lat, currentPlace.lang);
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
    Place place = Place.seData(0, "Your Location", position.latitude, position.longitude);
    return place;
  }


}