import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    print(path);
    return await openDatabase(join(path, 'map-integration-v1.db'),
        version: 1,
        onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('''
     
CREATE TABLE IF NOT EXISTS "ds_location" (
  "sr_no" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	"date"	TEXT,
  "place" TEXT,
	"latitude"	REAL,
  "longitude" REAL
);
''');

      print("DB created");
    });
  }

  /* clearDatabase() async {
    var path = await getDatabasesPath();
    String dbPath = join(path, 'tellatina.db');
    await deleteDatabase(dbPath);
  }*/

  clearDatabase(List<String> tables) async {
    if (_database != null) {
      tables.forEach((element) {
        _database!.execute("delete from " + element);
      });
    }
  }

/*
  insertQuestions(List<Question> questions) async {
    var batch = _db.batch();
    questions.forEach((element) async{
      batch.insert(Question.TABLE_NAME, element.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await batch.commit(noResult: true);
  }

  Future<List<Question>> getQuestions(int limit) async{
    List<Question> questions = new List();
    var results = await _db.query(Question.TABLE_NAME);
    results.forEach((result) {
      Question question = Question.fromJson(result);
      questions.add(question);
    });
    return questions;
  }*/
}
