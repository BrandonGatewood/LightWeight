import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:lightweight_app/db_helper/db.dart';

class Exercise {
  final String name;
  final int numOfTimesEntered;

  const Exercise({
    required this.name,
    required this.numOfTimesEntered
  });

  Exercise.fromMap(Map<String, dynamic> item):
    name = item['name'], numOfTimesEntered = item['numOfTimesEntered'];

  Map<String, dynamic> toMap() {
    return {
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

    Exercise newExercise = Exercise(name: name, numOfTimesEntered: 0);

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

  Future<bool> deleteExercise(String name) async {
    final Database db = await ExerciseDBHelper().openExercise();

    try {
      await db.delete(
        'exercises',
        where: "name = ?",
        whereArgs: [name]
      );
    }
    catch(err) {
      return false;
    }

    return true;
  }

  Future<bool> updateExercise(String name, String newName) async {
    final Database db = await ExerciseDBHelper().openExercise();

    try {
      await db.rawUpdate(
        'UPDATE exercises SET name = ? WHERE name = ?', [newName, name]);
    }
    catch(err) {
      return false;
    }

    return true;
  }
}