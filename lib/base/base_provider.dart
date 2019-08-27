import 'package:flutter/foundation.dart';

class BaseProvider with ChangeNotifier{
  bool _loader = false;

  bool get loader => _loader;

  set loader(bool loader){
    this._loader = loader;
    notifyListeners();
  }

  refresh(){
    notifyListeners();
  }
}