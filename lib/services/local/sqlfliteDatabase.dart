import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class sqlfliteDatabase {
  static final sqlfliteDatabase instance = sqlfliteDatabase._init();
  static Database? _database;
  sqlfliteDatabase._init();

  Future<Database?> get database async {
    return _database;
  }

  Future<Database> _initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), '../../BD/bd.db'),
      onCreate: (db, version) {
        _createRestaurants(db);
        _createTypeCuisine(db);
        _createUser(db);
        _createCritique(db);
      }
      version: 1,
    );
  }

  Future _createRestaurants(Database db) {
    return db.execute(
        '''
    CREATE TABLE restaurants(
      id INTEGER PRIMARY KEY,
      name TEXT,
      address TEXT,
      capacity INTEGER,
      tel TEXT,
      siret TEXT,
      website TEXT,
      url_photo TEXT,
      id_cuisine INTEGER,
      id_region INTEGER,
      nb_etoile INTEGER,
      horaires TEXT,
      gps_lat REAL,
      gps_long REAL
    )
    '''
    );
  }

  Future _createTypeCuisine(Database db) {
    return db.execute(
        '''
    CREATE TABLE TypeCuisine(
    )
    '''
    );
  }

  Future _createUser(Database db) {
    return db.execute(
        '''
    CREATE TABLE TypeCuisine(
    )
    '''
    );
  }

  Future _createCritique(Database db) {
    return db.execute(
        '''
    CREATE TABLE TypeCuisine(
    )
    '''
    );
  }


}
