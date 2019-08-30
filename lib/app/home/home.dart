import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pin_map/app/home/home_provider.dart';
import 'package:pin_map/app/search/search.dart';
import 'package:pin_map/model/place.dart';
import 'package:pin_map/state/event_state.dart';
import 'package:provider/provider.dart';

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
    HomeProvider _provider = Provider.of<HomeProvider>(context);

    return FutureBuilder(
      future: _provider.requestInitData(),
      initialData: null,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          switch(snapshot.data){
            case EventState.SUCCESS:            
              return RootHome();
              break;
            case EventState.ERROR:
              return ErrorMessage();
              break;
          }
        }
        return Loader();
      },
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

class RootHome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    return Column(
      children: <Widget>[
        Map(),
        ListAddress()
      ],
    );
  }
}

class Map extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    final Completer<GoogleMapController> _controller = Completer();        

    return Expanded(
      child: Stack(
        children: <Widget>[
          // MAP
          Consumer<HomeProvider>(
            builder: (context, provider, _) => GoogleMap(
              markers: provider.listMarker,
              onCameraMove: provider.cameraMove,
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
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

            return Container(              
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