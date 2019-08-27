import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pin_map/app/home/home_provider.dart';
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
    HomeProvider _provider = Provider.of<HomeProvider>(context, listen: false);

    return FutureBuilder(
      future: _provider.requestListPlace(),
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
    return Stack(
      children: <Widget>[
        Map(),
        IconSearch()
      ],
    );
  }

}

class Map extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    final Completer<GoogleMapController> _controller = Completer();        
    return Consumer<HomeProvider>(
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
          onPressed: (){},
          child: Icon(
            Icons.search
          ),
        ),
      ),
    );
  }
}