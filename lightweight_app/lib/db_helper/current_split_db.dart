import 'dart:async';
import "package:lightweight_app/db_helper/db.dart";
import "package:lightweight_app/db_helper/workout_db.dart";
import 'package:sqflite/sqflite.dart';

class CurrentSplit {
  final String id; 
  final String workoutIdString;
  List<Workout> workoutList = [];

  CurrentSplit({
    required this.id,
    required this.workoutIdString,
  });


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

  CurrentSplit generateEmptyCurrSplit() {
    String restDay = 'RestDay;RestDay;RestDay;RestDay;RestDay;RestDay;RestDay';

    return CurrentSplit(id: 'currSplit', workoutIdString: restDay);
  }

  Future<void> insertToSplit() async {
    final Database db = await CurrentSplitDBHelper().openCurrentSplit();
    final CurrentSplit newSplit = generateEmptyCurrSplit();

    await db.insert(
      'currentSplit',
      newSplit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

  }

  Future<CurrentSplit> getCurrentSplit(String id) async {
    final Database db = await CurrentSplitDBHelper().openCurrentSplit();
    final WorkoutsDBHelper workoutDb = WorkoutsDBHelper();
    workoutDb.openWorkouts();

    final List<Map<String, Object?>> currSplitListMap = await db.query('currentSplit');
    List<CurrentSplit> currentSplitList = currSplitListMap.map((e) => CurrentSplit.fromMap(e)).toList();
    CurrentSplit currSplit = currentSplitList[0];
    List<String> workoutIdList = currSplit.getWorkoutsIdList();


    for(int i = 0; i < workoutIdList.length; ++i) {
      if(workoutIdList[i] == 'RestDay') {
        Workout restDay = Workout(id: 'RestDay', name: 'Rest Day', exerciseIdString: '', setsString: '');

        currSplit.workoutList.add(restDay);
      }
      else {
        dynamic aWorkout = await workoutDb.getWorkoutById(workoutIdList[i]);

        if(aWorkout != null){
          currSplit.workoutList.add(aWorkout);
        }

      }
    }

    return currSplit;
  }
}