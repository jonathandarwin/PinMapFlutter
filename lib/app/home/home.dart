import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pin_map/app/home/home_provider.dart';
import 'package:pin_map/app/search/search.dart';
import 'package:pin_map/model/place.dart';
import 'package:pin_map/state/event_state.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class HomeLayout extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    return ChangeNotifierProvider(
      builder: (context) => HomeProvider(),
      child: SafeArea(
        child: Scaffold(
          body: LoadData(),
        ),
      ),
    );
  }
}

class LoadData extends StatelessWidget{
  @override
  Widget build(BuildContext context) {        
    return Consumer<HomeProvider>(
      builder: (context, provider, child) => FutureBuilder(
        future: provider.requestInitData(),
        initialData: null,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            switch(snapshot.data){
              case EventState.SUCCESS:            
                return Column(
                  children: <Widget>[
                    Map(),
                    ListAddress()                             
                  ],
                );
                break;
              case EventState.ERROR:
                return ErrorMessage();
                break;
            }
          }
          return Loader();
        },
      ),      
    );
  }

}

class Loader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ErrorMessage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    return Center(
      child: Text(
        'Error. Please try again',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15.0
        ),      
      ),
    );
  }
}

class Map extends StatelessWidget{
  @override
  Widget build(BuildContext context) {        

    return Expanded(
      child: Stack(
        children: <Widget>[
          // MAP
          Consumer<HomeProvider>(
            builder: (context, provider, _) => GoogleMap(
              markers: provider.listMarker,
              onCameraMove: provider.cameraMove,
              onMapCreated: (GoogleMapController controller){
                provider.controller = controller;
              },
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: provider.focus,
                zoom: 15
              ),
            ),
          ),
          // ICON SEARCH
          IconSearch()
        ],
      ),
    );
  }
}

class IconSearch extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    HomeProvider _provider = Provider.of<HomeProvider>(context, listen: false);
    return Align(
      alignment: Alignment.bottomRight,      
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SearchLayout()
              )
            ).then((value){
              _provider.refresh();
            });
          },
          child: Icon(
            Icons.search
          ),
        ),
      ),
    );
  }
}

class ListAddress extends StatelessWidget{
  @override
  Widget build(BuildContext context) {  
    return Expanded(
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) => ListView.builder(
          itemCount: provider.listPlace.length,
          itemBuilder: (context, i){
            Place place = provider.listPlace[i];
            if(i == 0){
              // NOT DISMISSIBLE
              return  GestureDetector(
                onTap: (){                               
                  provider.controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(place.lat, place.lang),
                        zoom: 15
                      )
                    )
                  );
                },
                child: Container(              
                  margin: EdgeInsets.all(15.0),              
                  child: Row(
                    children: <Widget>[
                      // ICON
                      Expanded(
                        flex: 2,
                        child: Icon(
                          Icons.person_pin_circle,
                          size: 30.0,
                          color: Colors.red,
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextDescription(place.description),
                            SizedBox(height: 5.0),
                            TextAddress(place.address)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            // DISMISSIBLE
            return Dismissible(              
              key: Key(place.id.toString()),
              onDismissed: (direction) async {                
                if(!await provider.deletePlace(place)){
                  Toast.show('Error. Please try again', context, duration: Toast.LENGTH_LONG);
                }
                provider.refresh();
              },
              child: GestureDetector(
                onTap: (){      
                  provider.controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(place.lat, place.lang),
                        zoom: 15
                      )
                    )
                  );
                },
                child: Container(              
                  margin: EdgeInsets.all(15.0),              
                  child: Row(
                    children: <Widget>[
                      // ICON
                      Expanded(
                        flex: 2,
                        child: Icon(
                          Icons.person_pin_circle,
                          size: 30.0,
                          color: Colors.red,
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextDescription(place.description),
                            SizedBox(height: 5.0),
                            TextAddress(place.address)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TextDescription extends StatelessWidget{
  final String _text;
  TextDescription(this._text);

  @override
  Widget build(BuildContext context) {  
    return Text(
      _text,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold                
      ),
    );
  }
}

class TextAddress extends StatelessWidget{
  final String _text;
  TextAddress(this._text);

  @override
  Widget build(BuildContext context) {  
    return Text(
      _text,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.grey
      ),
    );
  }
}