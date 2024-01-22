import 'dart:async';
import 'package:lightweight_app/db_helper/db.dart';
import 'package:sqflite/sqflite.dart';

class Workout {
  final String id; 
  final String name;
  final String exerciseList;
  final String setsList;

  const Workout({
    required this.id,
    required this.name,
    required this.exerciseList,
    required this.setsList,
  });

  Workout.fromMap(Map<String, dynamic> item):
    id = item['id'],
    name = item['name'], 
    exerciseList = item['exerciseList'],
    setsList = item['setsList'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exerciseList': exerciseList, 
      'setsList': setsList,
    };
  }

// getExercises converts the String, exerciseList, to a List<String>
  List<String> getExercises() {
    if(exerciseList.isEmpty) {
      return [];
    }
    else {
      return exerciseList.split(';');
    }
  }

  // getExerciseSets converts the String, setsList, to a List<String>
  List<String> getExerciseSets() {
    if(setsList.isEmpty) {
      return [];
    }
    else {
      return setsList.split(';');
    }
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

  Future<bool> insertWorkout(String name) async {
    final Database db = await WorkoutsDBHelper().openWorkouts();
    String id = DB().idGenerator();

    Workout newWorkout = Workout(id: id, name: name, exerciseList: '', setsList: '');

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

  Future<bool> updateWorkoutName(String name, String newName) async {
    final Database db = await WorkoutsDBHelper().openWorkouts();

    try {
      await db.rawUpdate(
        'UPDATE workouts SET name = ? WHERE name = ?', [newName, name], 
      );
    }
    catch(err) {
      return false;
    }

    return true;
  }
/*
  Future<bool> updateWorkoutExerciseList(String id, String newList) {
    return false;
  }
  */
  
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

  Future<Workout?> getWorkoutById(String id) async {
    List<Workout> workoutList = await getAllWorkouts();

    for(final workout in workoutList) {
      if(workout.id == id){
        return workout;
      }
    }

    return null; 
  }
  
  Future<dynamic> getWorkoutByName(String name) async {
    List<Workout> workoutList = await getAllWorkouts();

    for(final workout in workoutList) {
      if(workout.name == name){
        return workout;
      }
    }

    return null;
  }
}