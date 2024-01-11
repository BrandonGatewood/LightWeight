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
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            name Text NOT NULL,
            numOfTimesEntered INTEGER NOT NULL)'''
        );
      },
      version: 1,
    );
  }

 
  Future<void> insertExercise(String name) async {
    Exercise newExercise = Exercise(name: name, numOfTimesEntered: 0);

    final Database db = await ExerciseDBHelper().openExercise();

    await db.insert(
      'exercises', 
      newExercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
    
    
  }

  Future<List<Exercise>> getAllExercise() async {
    final Database db = await ExerciseDBHelper().openExercise();

    final List<Map<String, Object?>> maps = await db.query('exercises');

    return maps.map((e) => Exercise.fromMap(e)).toList(); 
  }
}