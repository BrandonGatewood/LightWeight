import 'dart:async';
import 'package:lightweight_app/db_helper/db.dart';
import 'package:lightweight_app/db_helper/exercise_db.dart';
import 'package:sqflite/sqflite.dart';

class Workout {
  final String id; 
  final String name;
  final String exerciseIdString;
  final String setsString;
  List<Exercise> exerciseList = [];
  List<String> setsList = [];

  Workout({
    required this.id,
    required this.name,
    required this.exerciseIdString,
    required this.setsString,
  });


  Workout.fromMap(Map<String, dynamic> item):
    id = item['id'],
    name = item['name'], 
    exerciseIdString = item['exerciseIdString'],
    setsString = item['setsString'];

  Workout.restDay():
    id = 'RestDay',
    name = 'Rest Day',
    exerciseIdString = '',
    setsString = '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exerciseIdString': exerciseIdString, 
      'setsString': setsString,
    };
  }

  // getExercises converts the String, exerciseList, to a List<String>
  List<String> getExerciseIdList() {
    if(exerciseIdString.isEmpty) {
      return [];
    }
    else {
      List<String> exerciseList = exerciseIdString.split(';');
      return exerciseList;
    }
  }

  // getExerciseSets converts the String, setsList, to a List<String>
  List<String> getExerciseSets() {
    if(setsString.isEmpty) {
      return [];
    }
    else {
      return setsString.split(';');
    }
  } 
}

class WorkoutsDBHelper {
  Future<Database> openWorkouts() {
    return DB().openDB(); 
  }

  Future<List<Workout>> getAllWorkouts() async {
    final Database db = await WorkoutsDBHelper().openWorkouts();
    final ExerciseDBHelper exerciseDb = ExerciseDBHelper();
    exerciseDb.openExercise();

    final List<Map<String, Object?>> workoutListMap = await db.query('workouts');
    List<Workout> workoutList = workoutListMap.map((e) => Workout.fromMap(e)).toList()..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),);

    for(int i = 0; i < workoutList.length; ++i) {
      List<String> aWorkoutExerciseIdList = workoutList[i].getExerciseIdList();
      workoutList[i].exerciseList = await exerciseDb.getExerciseList(aWorkoutExerciseIdList);
      workoutList[i].setsList = workoutList[i].getExerciseSets();
    }

    return workoutList;
  }



  Future<bool> insertWorkout(String name) async {
    final Database db = await WorkoutsDBHelper().openWorkouts();
    String id = DB().idGenerator();

    Workout newWorkout = Workout(id: id, name: name, exerciseIdString: '', setsString: '');

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

  Future<bool> updateWorkoutName(String id, String newName) async {
    final Database db = await WorkoutsDBHelper().openWorkouts();

    try {
      await db.rawUpdate(
        'UPDATE workouts SET name = ? WHERE id = ?', [newName, id], 
      );
    }
    catch(err) {
      return false;
    }

    return true;
  }

  Future<void> updateWorkoutExerciseList(Workout workout, String newExerciseIdString, String newExerciseSetsString) async {
    final Database db = await WorkoutsDBHelper().openWorkouts();

    await db.rawUpdate(
      'UPDATE workouts SET exerciseIdString = ?, setsString = ? WHERE id = ?', [newExerciseIdString, newExerciseSetsString, workout.id], 
    );
  }
  
  Future<bool> deleteWorkout(String id) async {
    final Database db = await WorkoutsDBHelper().openWorkouts();

    try {
      await db.delete(
        'workouts',
        where: "id = ?",
        whereArgs: [id]
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