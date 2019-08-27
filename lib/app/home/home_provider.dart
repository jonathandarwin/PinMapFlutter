import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pin_map/base/base_provider.dart';
import 'package:pin_map/repository/place_repository.dart';
import 'package:pin_map/state/event_state.dart';

class HomeProvider extends BaseProvider{
  // Repository
  PlaceRepository _placeRepository = PlaceRepository();

  // Attribute
  Set<Marker> _listMarker = Set<Marker>();

  // Getter
  Set<Marker> get listMarker => this._listMarker;

  // Setter
  set listMarker(Set<Marker> listMarker){
    this._listMarker = listMarker;
  }

  Future<int> requestListMarker(){
    
    return EventState.SUCCESS;
  }
}