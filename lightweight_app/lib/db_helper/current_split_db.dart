import 'dart:async';
import "package:lightweight_app/db_helper/db.dart";
import "package:lightweight_app/db_helper/workout_db.dart";
import 'package:sqflite/sqflite.dart';

class CurrentSplit {
  String id = ''; 
  String workoutIdString = '';
  List<Workout> workoutList = [];

  CurrentSplit() {
    id = '';
    workoutIdString = '';
  }

  CurrentSplit.emptySplit() {
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

  Future<bool> checkDbForSplit() async {
    final Database db = await CurrentSplitDBHelper().openCurrentSplit();

    try{
      await db.rawQuery('SELECT * FROM currentSplit WHERE id = ?', ['currSplit']);

      return true;
    }
    catch(err) {
      return false;
    }
  }

  Future<void> insertToSplit() async {
    final Database db = await CurrentSplitDBHelper().openCurrentSplit();

      CurrentSplit aSplit = CurrentSplit.emptySplit();

      await db.insert(
        'currentSplit',
        aSplit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
  }

  Future<CurrentSplit> getCurrentSplit(String id) async {
    final Database db = await CurrentSplitDBHelper().openCurrentSplit();
    String query = 'SELECT * FROM currentSplit WHERE id = ?';
    CurrentSplit currSplit;

    final List<Map<String, Object?>> currSplitListMap = await db.rawQuery(query, ['currSplit']);

    if(currSplitListMap.isNotEmpty) {
      final WorkoutsDBHelper workoutDb = WorkoutsDBHelper();
      workoutDb.openWorkouts();

      final List<Map<String, Object?>> currSplitListMap = await db.query('currentSplit');
      List<CurrentSplit> currentSplitList = currSplitListMap.map((e) => CurrentSplit.fromMap(e)).toList();
      currSplit = currentSplitList[0];
      List<String> workoutIdList = currSplit.getWorkoutsIdList();


      for(int i = 0; i < workoutIdList.length; ++i) {
        if(workoutIdList[i] == 'RestDay') {
          Workout restDay = Workout(id: 'RestDay', name: 'Rest Day', exerciseIdString: '', setsString: '');

          currSplit.workoutList.add(restDay);
        }
        else {
          dynamic aWorkout = await workoutDb.getWorkoutById(workoutIdList[i]);

          if(aWorkout != null) {
            currSplit.workoutList.add(aWorkout);
          }
        }
      }
       
    }
    else {
      await insertToSplit();

      return CurrentSplit.emptySplit();
    }
    return currSplit;
  }
}