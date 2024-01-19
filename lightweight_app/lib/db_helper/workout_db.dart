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

  Future<void> insertWorkout(String name, String exerciseList, String setsList) async {
    final Database db = await WorkoutsDBHelper().openWorkouts();

    Workout newWorkout = Workout(name: name, exerciseList: exerciseList, numOfSets: setsList);

    await db.insert(
      'workouts', 
      newWorkout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort, 
    );
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