import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ToDoDatabase {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'todo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE todos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertTask(String task) async {
    final db = await database;
    await db.insert('todos', {'task': task});
  }

  Future<List<String>> getTasks() async {
    final db = await database;
    final result = await db.query('todos');
    return result.map((row) => row['task'] as String).toList();
  }

  Future<void> deleteTask(int index) async {
    final db = await database;
    final tasks = await db.query('todos');
    if (index < tasks.length) {
      int id = tasks[index]['id'] as int;
      await db.delete('todos', where: 'id = ?', whereArgs: [id]);
    }
  }
}
