
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_tutorial/sqlite/data_model.dart';

class DB {
  Future<Database> initDB() async {
    // initialize database
    // Get a path to store data
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'MYDB.db'),
      onCreate: (database, version) async {
        // Create table
        await database.execute('''
          CREATE TABLE MYTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            subtitle TEXT NOT NULL
          )
        ''');
      },
      version: 1,
    );
  }

  // Insert data
  Future<bool> insertData(DataModel dataModel) async {
    final Database db = await initDB();
    db.insert('MYTable', dataModel.toMap());
    return true;
  }

  // Get data
  Future<List<DataModel>> getData() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas = await db.query('MYTable');
    return datas.map((e) => DataModel.fromMap(e)).toList();
  }

  // Edit data
  Future<void> update(DataModel dataModel, int id) async {
    final Database db = await initDB();
    await db.update('MYTable', dataModel.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  // Delete data
// Edit data
  Future<void> delete(int id) async {
    final Database db = await initDB();
    await db.delete('MYTable', where: 'id = ?', whereArgs: [id]);
  }
}