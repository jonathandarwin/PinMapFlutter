import 'package:flutter/material.dart';
import 'package:pin_map/app/home/home.dart';

void main() => runApp(Main());

class Main extends StatelessWidget{
  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      title: 'PinMap',
      home: HomeLayout(),
    );
  }
}