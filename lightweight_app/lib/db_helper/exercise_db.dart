import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Exercise {
  final int id; 
  final String name;
  final int numOfTimesEntered;

  const Exercise({
    required this.id,
    required this.name,
    required this.numOfTimesEntered
  });

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
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'exercise.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE exercises(id INTEGER PRIMARY KEY, name Text, sets INTEGER, numerOfTimesEntered INTEGER)',
        );
      },
      version: 1,
    );

    return database;
  }

  Future<void> insertExercise(Exercise anExercise, Future<Database> database) async {

    final db = await database;

    await db.insert(
      'exercises', 
      anExercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  Future<List<Exercise>> getAllExercise(Future<Database> database) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('exercises');

    return List.generate(maps.length, (i) {
      return Exercise(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        numOfTimesEntered: maps[i]['numOfTimesEntered'] as int,
      );
    });
  }
}