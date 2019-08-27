import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pin_map/app/home/home_provider.dart';
import 'package:provider/provider.dart';

class HomeLayout extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    return ChangeNotifierProvider(
      builder: (_) => HomeProvider(),
      child: SafeArea(
        child: Scaffold(
          
        ),
      ),
    );
  }
}

class Map extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    final Completer<GoogleMapController> _controller = Completer();
    
    return Consumer<HomeProvider>(
      builder: (context, provider, _) => GoogleMap(
        markers: provider.marker,
        onCameraMove: provider.cameraMove,
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: provider.center,
          zoom: 15
        ),
      ),
    );
  }

}