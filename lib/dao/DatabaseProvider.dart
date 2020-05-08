import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  
  DatabaseProvider._();
  static final DatabaseProvider provider = DatabaseProvider._();
  static Database _database;

  static Future<Database> get database async {
    if(_database != null) return _database;
    
    _database = await _initDatabase();
    return _database;
  }

  static _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'sqflite_demo.db'),
      
      onCreate: (database, version) async {
        await db.execute('''

        CREATE TABLE user (
          user_id INTEGER PRIMARY KEY,
          username TEXT,
          password TEXT,
          
        );

        CREATE TABLE email (
          email_id INTEGER PRIMARY KEY,
          email TEXT,
          user_id INTEGER,
          FOREIGN KEY(user_id) REFERENCES user(user_id)
        );
        ''');
        // pourrait aussi être lu d'un fichier, pour par exemple exécuter des requêtes à part de flutter
      },
      // utilisé pour le suivi des updates de la base de données
      version: 1
    );
  }
}