import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    WidgetsFlutterBinding.ensureInitialized();
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''CREATE TABLE exercises(
            id INTEGER PRIMARY KEY NOT NULL,
            name Text NOT NULL,
            numOfTimesEntered INTEGER NOT NULL)'''
        );
      },
      version: 1,
    );
  }

  Future<bool> insertExercise(String name) async {
    final Database db = await ExerciseDBHelper().openExercise();

    // check if name is already in the workout list
    final List<Map<String, Object?>> maps = await db.query(
      'exercises',
      where: "name = ?",
      whereArgs: [name]
    );

    // exercise not found. Insert into db and return true
    if(maps.isEmpty) {
      Exercise newExercise = Exercise(name: name, numOfTimesEntered: 0);

      await db.insert(
        'exercises', 
        newExercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return true;
    }
    else {
      return false;
    }
  }

  Future<List<Exercise>> getAllExercise() async {
    final Database db = await ExerciseDBHelper().openExercise();

    final List<Map<String, Object?>> maps = await db.query('exercises');

    return maps.map((e) => Exercise.fromMap(e)).toList(); 
  }

  Future<bool> deleteItem(String name) async {
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