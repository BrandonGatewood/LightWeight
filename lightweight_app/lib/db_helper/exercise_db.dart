import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:lightweight_app/db_helper/db.dart';

class Exercise {
  final String id;
  final String name;
  final int numOfTimesEntered;

  const Exercise({
    required this.id,
    required this.name,
    required this.numOfTimesEntered
  });

  Exercise.fromMap(Map<String, dynamic> item):
    id = item['id'], name = item['name'], numOfTimesEntered = item['numOfTimesEntered'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'numOfTimesEntered': numOfTimesEntered,
    };
  }
}

class ExerciseDBHelper {
  Future<Database> openExercise() async {
    return DB().openDB();
  }

  Future<bool> insertExercise(String name) async {
    final Database db = await ExerciseDBHelper().openExercise();

    String id = DB().idGenerator(); 

    Exercise newExercise = Exercise(id: id, name: name, numOfTimesEntered: 0);

    // insert new exercise into db and abort if primary key (name) already exists
    try{
      await db.insert(
        'exercises', 
        newExercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      return true;
    }
    catch(err) {
      return false;
    }
  }

  Future<List<Exercise>> getAllExercise() async {
    final Database db = await ExerciseDBHelper().openExercise();

    final List<Map<String, Object?>> maps = await db.query('exercises');

    return maps.map((e) => Exercise.fromMap(e)).toList()..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),);
  }

  Future<List<Exercise>> getExerciseList(List<String> exerciseIdList) async {
    final Database db = await ExerciseDBHelper().openExercise();
    final List<Map<String, Object?>> maps = await db.query('exercises');

    List<Exercise> exerciseList = [];
    List<Exercise> allExerciseList = maps.map((e) => Exercise.fromMap(e)).toList()..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),);

    for(int i = 0; i < allExerciseList.length; ++i) {
      if(exerciseIdList[i] == allExerciseList[i].id) {
        exerciseList.add(allExerciseList[i]);
      }
    }

    return exerciseList;
  }

  Future<void> deleteExercise(String id) async {
    final Database db = await ExerciseDBHelper().openExercise();

      await db.delete(
        'exercises',
        where: "id = ?",
        whereArgs: [id]
      );
  }

  Future<bool> updateExercise(String id, String newName) async {
    final Database db = await ExerciseDBHelper().openExercise();

    try {
      await db.rawUpdate(
        'UPDATE exercises SET name = ? WHERE id = ?', [newName, id]);
    }
    catch(err) {
      return false;
    }

    return true;
  }

  Future<dynamic> getExercise(String id) async {
    List<Exercise> exerciseList = await getAllExercise();

    for(final exercise in exerciseList) {
      if(exercise.id == id) {
        return exercise;
      }
    }

    return null;
  }

  Future<String> getExerciseName(String id) async {
    List<Exercise> exerciseList = await getAllExercise();

    for(final exercise in exerciseList) {
      if(exercise.id == id) {
        return exercise.name;
      }
    }

    return '';
  }
}