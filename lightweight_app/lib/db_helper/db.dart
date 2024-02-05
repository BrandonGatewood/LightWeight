import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  Future<Database> openDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''CREATE TABLE exercises(
          id TEXT PRIMARY KEY NOT NULL,
          name TEXT NOT NULL,
          repsString TEXT NOT NULL,
          weightString TEXT NOT NULL,
          maxWeight INTEGER NOT NULL,
          maxWeightReps INTEGER NOT NULL,
          maxReps INTEGER NOT NULL,
          maxRepsWeight INTEGER NOT NULL
          )'''
        );

        await database.execute(
          '''CREATE TABLE workouts(
            id TEXT PRIMARY KEY NOT NULL,
            name TEXT NOT NULL,
            exerciseIdString TEXT NOT NULL,
            setsString TEXT NOT NULL
          )'''
        );

        await database.execute(
          '''CREATE TABLE currentSplit(
            id TEXT PRIMARY KEY NOT NULL,
            workoutIdString TEXT NOT NULL
          )'''
        );

        await database.execute(
          '''CREATE TABLE user(
            id TEXT PRIMARY KEY NOT NULL,
            name TEXT NOT NULL,
            bodyWeightString TEXT NOT NULL,
            date INTEGER NOT NULL,
            nextDate INTEGER NOT NULL
          )'''
        );
      },
      version: 1,
    );
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }
}