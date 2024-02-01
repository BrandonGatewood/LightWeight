import 'dart:async';
import 'package:lightweight_app/db_helper/db.dart';
import 'package:sqflite/sqflite.dart';

class User {
  String id = '';
  String name = '';
  String bodyWeightString = '';
  int date = 0;
  int nextDate = 0;

  User() {
    id = 'UserId';
    name = 'username';
    bodyWeightString = '--';
    date = 0;
    nextDate = 0;
  }

  User.fromMap(Map<String, dynamic> item):
    id = item['id'],
    name = item['name'],
    bodyWeightString = item['bodyWeightString'],
    date = item['date'],
    nextDate = item['nextDate'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bodyWeightString': bodyWeightString,
      'date': date,
      'nextDate': nextDate,
    };
  }

  void setUser(User aUser) {
    id = aUser.id;
    name = aUser.name;
    bodyWeightString = aUser.bodyWeightString;
    date = aUser.date;
    nextDate = aUser.nextDate;
  }
  
  String getCurrentBodyWeight() {
    List<String> bw = bodyWeightString.split(';');

    return bw[bw.length - 1];
  }

  List<int> getBodyWeightList() {
    List<int> bw = [];

    List<String> bwString = bodyWeightString.split(';'); 

    for(int i = 1; i < bwString.length; ++i) {
      int data = int.parse(bwString[i]);
      bw.add(data);
    }

    return bw;
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
    final List<Map<String, Object?>> maps = await db.query('user');
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

  Future<void> updateName(String name) async {
    final Database db = await UserDBHelper().openUser();
    String query = 'UPDATE user SET name = ? WHERE id = ?';

    await db.rawUpdate(query, [name, 'UserId']);
  }

  Future<void> updateBodyWeight(String bw) async {
    final Database db = await UserDBHelper().openUser();
    String query = 'UPDATE user SET bodyWeightString = ? WHERE id = ?';

    await db.rawUpdate(query, [bw, 'UserId']);
  }

  Future<void> updateDate(int date) async {
    final Database db = await UserDBHelper().openUser();
    int nextDate;

    if(date == 12) {
      nextDate = 1;
    }
    else {
      nextDate = date + 1;
    }

    String query = 'UPDATE user SET date = ?, nextDate = ? WHERE id = ?';

    await db.rawUpdate(query, [date, nextDate, 'UserId']);
  }
  // update name
}