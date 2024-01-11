import 'package:nova_chrono/domain/model/common_task_name.dart';
import 'package:nova_chrono/domain/repository/common_task_name_repository.dart';
import 'package:nova_chrono/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class CommonTaskNameRepositoryImpl implements CommonTaskNameRepository {
  static const String table = 'common_task_name';
  static const uuid = Uuid();

  @override
  String nextIdentity() {
    return uuid.v1();
  }

  @override
  Future<void> add(CommonTaskName commonTaskName) async {
    var database = databaseProvider.database;

    await database.insert(
        table,
        commonTaskName.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  @override
  Future<void> updateCommonTaskName(CommonTaskName commonTaskName) async {
    var database = databaseProvider.database;

    await database.update(
        table,
        commonTaskName.toMap(),
        where: 'id = ?',
        whereArgs: [commonTaskName.id]
    );
  }

  @override
  Future<void> deleteCommonTaskName(String id) async {
    var database = databaseProvider.database;

    await database.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<CommonTaskName>> getAll() async {
    var database = databaseProvider.database;

    final List<Map<String, dynamic>> maps = await database.query(
      table
    );

    return List.generate(maps.length, (i) {
      var id = maps[i]['id'] as String;
      var name = maps[i]['name'] as String;

      return CommonTaskName(
          id,
          name
      );
    });
  }

  @override
  Future<CommonTaskName> getById(String id) async {
    var database = databaseProvider.database;

    final List<Map<String, dynamic>> maps = await database.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );

    var idFromDB = maps.first['id'] as String;
    var nameFromDB = maps.first['name'] as String;

    return CommonTaskName(
      idFromDB,
      nameFromDB,
    );
  }
}