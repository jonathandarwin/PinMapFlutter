import 'package:geocoder/geocoder.dart';
import 'package:pin_map/base/base_provider.dart';
import 'package:pin_map/model/place.dart';
import 'package:pin_map/repository/place_repository.dart';
import 'package:pin_map/state/event_state.dart';
import 'package:pin_map/util/location_util.dart';

class SearchProvider extends BaseProvider{
  PlaceRepository _placeRepository = PlaceRepository();

  String _search;
  String _description;
  List<Place> _listPlace = List<Place>();  

  String get search => this._search;
  String get description => this._description;
  List<Place> get listPlace => this._listPlace;  

  set search(String search) => this._search = search;  
  set description(String description) => this._description = description;
  set listPlace(List<Place> listPlace) => this._listPlace = listPlace;
  
  Future<int> doSearch() async {
    try{
      List<Address> listAddress = await LocationUtil.getAddressByDescription(search);            
      listPlace.clear();
      if(listAddress != null && listAddress.length > 0){        
        for(int i=0; i<listAddress.length; i++){
          Address address = listAddress[i];
          listPlace.add(
            Place.seData(i, address.addressLine, '', address.coordinates.latitude, address.coordinates.longitude)
          );
        }
        return EventState.SUCCESS;
      }
      else{
        return EventState.NO_DATA;
      }
    }
    on Exception catch(e){
      print('<ERR> $e');
      return EventState.ERROR;
    }            
  }

  Future<bool> insertAddress(Place place) async {
    place.description = description;
    int result = await _placeRepository.insertPlace(place);
    if(result != -1)
      return true;
    return false;
  }
}