import 'dart:async';
import 'package:lightweight_app/db_helper/db.dart';
import 'package:sqflite/sqflite.dart';

class Workout {
  final String name;
  final String exerciseList;
  final String numOfSets;

  const Workout({
    required this.name,
    required this.exerciseList,
    required this.numOfSets,
  });

  Workout.fromMap(Map<String, dynamic> item):
    name = item['name'], 
    exerciseList = item['exerciseList'],
    numOfSets = item['numOfSets'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'exerciseList': exerciseList, 
      'numOfSets': numOfSets,
    };
  }
}

class WorkoutsDBHelper {
  Future<Database> openWorkouts() {
    return DB().openDB(); 
  }

  Future<List<Workout>> getAllWorkouts() async {
    final Database db = await WorkoutsDBHelper().openWorkouts();

    final List<Map<String, Object?>> maps = await db.query('workouts');

    return maps.map((e) => Workout.fromMap(e)).toList();
  }

  Future<bool> insertWorkout(String name, Map<String, int> exerciseMap) async {
    final Database db = await WorkoutsDBHelper().openWorkouts();
    String exerciseList = '';
    String numOfSets = '';

    // Convert map to strings
    exerciseMap.forEach((key, value) {
      exerciseList += '$key;';  
      numOfSets += '$value;';
    });

    Workout newWorkout = Workout(name: name, exerciseList: exerciseList, numOfSets: numOfSets);

    try {
      await db.insert(
        'workouts', 
        newWorkout.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort, 
      );

      return true;
    }
    catch(err) {
      return false;
    }
  }

  Future<bool> updateWorkout(String name, String newName) async {
    final Database db = await WorkoutsDBHelper().openWorkouts();

    try {
      await db.rawUpdate(
        'UPDATE workouts SET name = ? WHERE name = ?', [newName, name]);
    }
    catch(err) {
      return false;
    }

    return true;
  }
  
  Future<bool> deleteWorkout(String name) async {
    final Database db = await WorkoutsDBHelper().openWorkouts();

    try {
      await db.delete(
        'workouts',
        where: "name = ?",
        whereArgs: [name]
      );
    }
    catch(err) {
      return false;
    }

    return true;
  }


}