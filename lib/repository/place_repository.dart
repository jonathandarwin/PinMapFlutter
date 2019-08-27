import 'package:pin_map/base/base_repository.dart';
import 'package:pin_map/model/place.dart';

class PlaceRepository extends BaseRepository{
  Future<List<Place>> requestListMarker() async {
    final db = await database;
    var result = await db.rawQuery("SELECT * FROM msPlace");
    List<Place> listPlace = result.isNotEmpty ? result.map((model) => Place.fromJson(model)).toList() : [];
  }
}