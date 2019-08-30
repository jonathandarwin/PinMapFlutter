import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BaseRepository{
   BaseRepository();

  BaseRepository._();
  static final BaseRepository db = BaseRepository._();

  Database _database;
  
  Future<Database> get database async {
    if(_database == null){
      _database = await initDB();
    }
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path + "pinmap.db");
    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE msPlace('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
          'address TEXT,' +
          'description TEXT,' +
          'lat REAL,' +
          'lang REAL)'
      );
    });
  }
}