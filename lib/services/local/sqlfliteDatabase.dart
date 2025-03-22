import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlfliteDatabase {
  static final SqlfliteDatabase instance = SqlfliteDatabase._init();
  static Database? _database;
  SqlfliteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'bd.db'),
      onCreate: (db, version) {
        _createRestaurants(db);
        _createTypeCuisine(db);
        _createUser(db);
        _createCritique(db);
        _createRestaurantsPreferees(db);
        _createCuisinePreferees(db);
      },
      version: 1,
    );
  }

  Future _createRestaurants(Database db) {
    return db.execute(
        '''
    CREATE TABLE restaurants(
      id INTEGER PRIMARY KEY,
      name TEXT,
      address TEXT
    )
    '''
    );
  }

  Future _createTypeCuisine(Database db) {
    return db.execute(
        '''
    CREATE TABLE TypeCuisine(
      id INTEGER PRIMARY KEY,
      nom_cuisine TEXT
    )
    '''
    );
  }

  Future _createUser(Database db) {
    return db.execute(
        '''
    CREATE TABLE User(
      email TEXT PRIMARY KEY,
      connected BOOLEAN,
      localisation TEXT
    )
    '''
    );
  }

  Future _createCritique(Database db) {
    return db.execute(
        '''
    CREATE TABLE Critique(
      id INTEGER PRIMARY KEY,
      message TEXT,
      note INTEGER,
      restaurant_id INTEGER,
      email TEXT,
      FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
      FOREIGN KEY (email) REFERENCES User(email)
    )
    '''
    );
  }

  Future _createRestaurantsPreferees(Database db) async {
    return db.execute(
        '''
    CREATE TABLE restaurants_preferees(
      email TEXT,
      restaurant_id INTEGER,
      PRIMARY KEY (email, restaurant_id),
      FOREIGN KEY (email) REFERENCES user(email),
      FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
    )
  ''');
  }

  Future _createCuisinePreferees(Database db) async {
    return db.execute(
        '''
    CREATE TABLE cuisines_preferees(
      email TEXT,
      cuisine_id INTEGER,
      PRIMARY KEY (email, cuisine_id),
      FOREIGN KEY (email) REFERENCES User(email),
      FOREIGN KEY (cuisine_id) REFERENCES TypeCuisine(id)
    )
  ''');
  }
}
