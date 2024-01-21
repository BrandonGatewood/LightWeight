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
    String id = DB().idGenerator();

    Workout newWorkout = Workout(id: id, name: name, exerciseList: exerciseList, setsList: setsList);

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

  Future<Workout?> getAWorkout(String id) async {
    List<Workout> workoutList = await getAllWorkouts();

    for(int i = 0; i < workoutList.length; ++i) {
      if(workoutList[i].id == id){
       return workoutList[i];
      }
    }

    return null; 
  }

}