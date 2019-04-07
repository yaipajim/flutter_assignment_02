import 'package:sqflite/sqflite.dart';

final String todoTable = "todo";
final String idColumn = "_id";
final String todoItemColumn = "title";
final String isDoneColumn = "done";

class Todo {
  int id;
  String title;
  bool done;

  Todo();
  Todo.formMap(Map<String, dynamic> map) {
    this.id = map[idColumn];
    this.title = map[todoItemColumn];
    this.done = map[isDoneColumn] == 1;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      todoItemColumn: title,
      isDoneColumn: done,
    };
    if (id != null) { map[idColumn] = id; }
    return map;
  }

  @override
  String toString() { return '${this.id}, ${this.title}, ${this.done}'; }

}

class TodoCRUD {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $todoTable (
        $idColumn integer primary key autoincrement,
        $todoItemColumn text not null,
        $isDoneColumn integer not null
      )
      ''');
    });
  }

  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(todoTable, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async {
    List<Map<String, dynamic>> maps = await db.query(todoTable,
        columns: [idColumn, todoItemColumn, isDoneColumn],
        where: '$idColumn = ?',
        whereArgs: [id]);
        maps.length > 0 ? new Todo.formMap(maps.first) : null;
  }

  Future<int> delete(int id) async {
    return await db.delete(todoTable, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    return db.update(todoTable, todo.toMap(),
        where: '$idColumn = ?', whereArgs: [todo.id]);
  }

  Future<List<Todo>> getAll() async {
    await this.open("todo.db");
    var res = await db.query(todoTable, columns: [idColumn, todoItemColumn, isDoneColumn]);
    List<Todo> todoList = res.isNotEmpty ? res.map((c) => Todo.formMap(c)).toList() : [];
    return todoList;
  }

  Future close() async => db.close();

}