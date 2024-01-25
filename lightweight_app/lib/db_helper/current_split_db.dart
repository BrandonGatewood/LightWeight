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
    for(int i = 0; i < 7; ++i){
      workoutList.add(Workout.restDay());
    }

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
    List<CurrentSplit> currSplitList = currSplitListMap.map((e) => CurrentSplit.fromMap(e)).toList();
    CurrentSplit currSplit = currSplitList[0];

    List<String> workoutIdList = currSplit.getWorkoutsIdList(); 

    final WorkoutsDBHelper workoutDb = WorkoutsDBHelper();
    workoutDb.openWorkouts();

    for(int i = 0; i < 7; ++i) {
      if(workoutIdList[i] == 'RestDay') {
        currSplit.workoutList.add(Workout.restDay());
      }
      else {
        Workout? aWorkout = await workoutDb.getWorkoutById(workoutIdList[i]);

        if(aWorkout != null) {
          currSplit.workoutList.add(aWorkout);
        }
      }
    }

    return currSplit;
  }

  Future<void> updateCurrentSplit(String newWorkoutIdList) async {
    final Database db = await CurrentSplitDBHelper().openCurrentSplit();
    String query = 'UPDATE currentSplit SET workoutIdString = ? WHERE id = ?';
    await db.rawUpdate(
      query, [newWorkoutIdList, 'currSplit']
    );
  }
}