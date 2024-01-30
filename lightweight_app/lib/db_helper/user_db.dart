import 'dart:async';
import 'package:lightweight_app/db_helper/db.dart';
import 'package:sqflite/sqflite.dart';

class User {
    String id = '';
    String name = '';
    String bodyWeightString = '';
    String dateString = '';

    User() {
      id = 'UserId';
      name = '';
      bodyWeightString = '';
      dateString = '';
    }

    User.fromMap(Map<String, dynamic> item):
      id = item['id'],
      name = item['name'],
      bodyWeightString = item['bodyWeightString'],
      dateString = item['dateString'];

    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'name': name,
        'bodyWeightString': bodyWeightString,
        'dateString': dateString,
      };
    }
}

class UserDBHelper {
  Future<Database> openUser() {
      return DB().openDB();
  }

  Future<void> insertUser(User aUser) async {
    final Database db = await UserDBHelper().openUser();

    await db.insert(
      'user',
      aUser.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<User> getUser() async {
    final Database db = await UserDBHelper().openUser();
    User aUser;
    final List<Map<String, Object?>> maps = await db.query('exercises');
    List<User> userList = maps.map((e) => User.fromMap(e)).toList();

    if(userList.isEmpty) {
      aUser = User();
      await insertUser(aUser);
    }
    else {
      aUser = userList[0];
    }

    return aUser;
  }

  // update dateString
  // update name
  // update bodyweight
}