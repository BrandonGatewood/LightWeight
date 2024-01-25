import 'dart:async';
import "package:lightweight_app/db_helper/db.dart";
import "package:lightweight_app/db_helper/workout_db.dart";
import 'package:sqflite/sqflite.dart';

class CurrentSplit {
  String id = ''; 
  String workoutIdString = '';
  List<Workout> workoutList = [];

  CurrentSplit() {
    id = 'currSplit';
    workoutIdString = 'RestDay;RestDay;RestDay;RestDay;RestDay;RestDay;RestDay';
  }

  CurrentSplit.fromMap(Map<String, dynamic> item):
    id = item['id'],
    workoutIdString = item['workoutIdString'];


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workoutIdString': workoutIdString,
    };
  }

  List<String> getWorkoutsIdList() {
    if(workoutIdString.isEmpty) {
      return [];
    }
    else {
      return workoutIdString.split(';');
    }
  }
}

class CurrentSplitDBHelper {
  Future<Database> openCurrentSplit() {
    return DB().openDB();
  }

  Future<void> insertToSplit(CurrentSplit aSplit) async {
    final Database db = await CurrentSplitDBHelper().openCurrentSplit();

    await db.insert(
      'currentSplit',
      aSplit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<CurrentSplit> getCurrentSplit() async {
    final Database db = await CurrentSplitDBHelper().openCurrentSplit();
    String query = 'SELECT * FROM currentSplit WHERE id = ?';
    
    List<Map<String, Object?>> currSplitListMap = await db.rawQuery(query, ['currSplit']);

    if(currSplitListMap.isNotEmpty) {
      final WorkoutsDBHelper workoutDb = WorkoutsDBHelper();
      workoutDb.openWorkouts();

    }
    List<CurrentSplit> l = currSplitListMap.map((e) => CurrentSplit.fromMap(e)).toList();
    return l[0];
  }
}