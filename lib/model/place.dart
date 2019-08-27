class Place{
  int _id;
  String _description;
  double _lat;
  double _lang;

  Place();

  Place.seData(
    this._id,
    this._description,
    this._lat,
    this._lang
  );

  Place.fromJson(Map<String, dynamic> data){
    _id = data['id'];
    _description = data['description'];
    _lat = data['lat'];
    _lang = data['lang'];
  }

  int get id => this._id;
  String get description => this._description;
  double get lat => this._lat;
  double get lang => this._lang;

  set id(int id){
    this._id = id;
  }
  set description(String description){
    this._description = description;
  }
  set lat(double lat){
    this._lat = lat;
  }
  set lang(double lang){
    this._lang = lang;
  }
}