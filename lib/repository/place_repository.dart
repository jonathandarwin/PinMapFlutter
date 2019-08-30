import 'package:pin_map/base/base_repository.dart';
import 'package:pin_map/model/place.dart';

class PlaceRepository extends BaseRepository{
  Future<List<Place>> requestListPlace() async {
    final db = await database;
    var result = await db.rawQuery("SELECT * FROM msPlace");
    List<Place> listPlace = result.isNotEmpty ? result.map((model) => Place.fromJson(model)).toList() : [];
    return listPlace;
  }

  Future<int> insertPlace(Place place) async {
    final db = await database;
    var result = await db.rawInsert('INSERT INTO msPlace(address, description, lat, lang) VALUES(?,?,?,?)', [place.address, place.description, place.lat, place.lang]);
    return result;
  }

  Future<int> deletePlace(Place place) async {
    final db = await database;
    var result = await db.delete('msPlace', where: 'id = ${place.id}');
    return result;
  }
}