import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolistsqlite/model/model.dart';

class DBhelper {
  static Database? _dbd;

  Future<Database?> get dbd async {
    if (_dbd != null) {
      return _dbd;
    }
    _dbd = await initDatabase();
    return _dbd;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Todo.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  void _createDatabase(Database dbd, int version) async {
    await dbd.execute('''
      CREATE TABLE mytodo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        desc TEXT NOT NULL
      )
    ''');
  }

  Future<Todomodel> insert(Todomodel todomodel) async {
    var dbClient = await dbd;
    await dbClient?.insert('mytodo', todomodel.toMap());
    return todomodel;
  }

  Future<List<Todomodel>> getDataList() async {
    final Database? db = await this.dbd;
    final List<Map<String, dynamic>> queryResult =
        await db!.rawQuery('SELECT * FROM mytodo');
    return queryResult.map((e) => Todomodel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    final Database? dbClient = await dbd;
    return await dbClient!.delete('mytodo', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Todomodel todomodel) async {
    final Database? dbClient = await dbd;
    return await dbClient!.update('mytodo', todomodel.toMap(),
        where: 'id = ?', whereArgs: [todomodel.id]);
  }
}
