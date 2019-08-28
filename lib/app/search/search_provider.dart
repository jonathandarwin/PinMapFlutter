import 'package:geocoder/geocoder.dart';
import 'package:pin_map/base/base_provider.dart';
import 'package:pin_map/model/place.dart';
import 'package:pin_map/state/event_state.dart';
import 'package:pin_map/util/location_util.dart';

class SearchProvider extends BaseProvider{
  String _search;
  List<Place> _listPlace;

  String get search => this._search;
  List<Place> get listPlace => this._listPlace;

  set search(String search) => this._search = search;  
  set listPlace(List<Place> listPlace) => this._listPlace = listPlace;
  
  Future<int> doSearch() async {
    try{
      List<Address> listAddress = await LocationUtil.getAddressByDescription(search);      
      print(listAddress.length);
      if(listAddress != null && listAddress.length > 0){
        listPlace.clear();
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
}