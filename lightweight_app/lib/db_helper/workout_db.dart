import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import './exercise_db.dart';

class Workout {
  final String name;
  final List<Exercise> workoutList;
  final List<int> numOfReps;

  const Workout({
    required this.name,
    required this.workoutList,
    required this.numOfReps,
  });

  Workout.fromMap(Map<String, dynamic> item):
    name = item['name'], 
    workoutList = item['workoutList'],
    numOfReps = item['numOfReps'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'workoutList': workoutList, 
      'numOfReps': numOfReps,
    };
  }
}

class WorkoutsDBHelper {
  Future<Database> openWorkouts() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''CREATE TABLE workouts(
            name Text PRIMARY KEY NOT NULL,
            workoutList Text NOT NULL,
            numOfReps Text NOT NULL
          )'''
        );
      },
      version: 1,
    );
  }
}