import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:startup_namer/repository/employee.dart';

class DBService {
  var database = null;

  void initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  void createTable() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'emp_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE employees(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, role TEXT, doj INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insert(Map data) async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'emp_database.db'),
    );
    await database.insert('employees', data);
  }

  Future<List<Employee>> getemployee() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'emp_database.db'),
    );

    final List<Map<String, dynamic>> maps = await database.query('employees');

    return List.generate(maps.length, (int index) {
      return Employee(
          id: maps[index]['id'],
          name: maps[index]['name'],
          role: maps[index]['role'],
          doj: maps[index]['doj'].toString());
    });
  }

  Future<void> deleteEmployee(int id) async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'emp_database.db'),
    );

    await database.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> update(Employee employee) async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'emp_database.db'),
    );

    await database.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }
}
