import 'dart:async';
import 'package:lightweight_app/db_helper/db.dart';
import 'package:lightweight_app/db_helper/exercise_db.dart';
import 'package:sqflite/sqflite.dart';

class Workout {
  final String id; 
  final String name;
  final String exerciseIdString;
  final String setsString;
  late List<Exercise> exerciseList;

  Workout({
    required this.id,
    required this.name,
    required this.exerciseIdString,
    required this.setsString,
    required this.exerciseList,
  });


  Workout.fromMap(Map<String, dynamic> item):
    id = item['id'],
    name = item['name'], 
    exerciseIdString = item['exerciseList'],
    setsString = item['setsList'],
    exerciseList = [];


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exerciseList': exerciseIdString, 
      'setsList': setsString,
    };
  }

  // getExercises converts the String, exerciseList, to a List<String>
  List<String> getExerciseIdList() {
    if(exerciseIdString.isEmpty) {
      return [];
    }
    else {
      return exerciseIdString.split(';');
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

  List<Exercise> getExerciseList() {
    final ExerciseDBHelper exerciseDb = ExerciseDBHelper();
    List<Exercise> list = [];
    exerciseDb.openExercise().whenComplete(() async {
    List<String> exerciseIdList = getExerciseIdList();

      for(int j = 0; j < exerciseIdList.length; ++j) {
        List<Exercise> anExercise = await exerciseDb.getExercise(exerciseIdList[j]);
        if(anExercise.isNotEmpty) {
          list.add(anExercise[0]);
        }
      }

    });


    return list;
  }
}

class WorkoutsDBHelper {
  Future<Database> openWorkouts() {
    return DB().openDB(); 
  }

  Future<List<Workout>> getAllWorkouts() async {
    final Database db = await WorkoutsDBHelper().openWorkouts();


    final List<Map<String, Object?>> workoutListMap = await db.query('workouts');
    return workoutListMap.map((e) => Workout.fromMap(e)).toList();
  }



  Future<bool> insertWorkout(String name) async {
    final Database db = await WorkoutsDBHelper().openWorkouts();
    String id = DB().idGenerator();

    Workout newWorkout = Workout(id: id, name: name, exerciseIdString: '', setsString: '', exerciseList: []);

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

  Future<void> updateWorkoutExerciseList(Workout workout, String newExerciseList, String newExerciseSetsList) async {
    final Database db = await WorkoutsDBHelper().openWorkouts();

    await db.rawUpdate(
      'UPDATE workouts SET exerciseList = ?, setsList = ? WHERE id = ?', [newExerciseList, newExerciseSetsList, workout.id], 
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