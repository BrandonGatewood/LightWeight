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
          numOfTimesEntered INTEGER NOT NULL
          )'''
        );

        await database.execute(
          '''CREATE TABLE workouts(
            id TEXT PRIMARY KEY NOT NULL,
            name TEXT NOT NULL,
            exerciseList TEXT NOT NULL,
            setsList TEXT NOT NULL
          )'''
        );

        await database.execute(
          '''CREATE TABLE currentSplit(
            id TEXT PRIMARY KEY NOT NULL,
            name TEXT NOT NULL,
            workoutList Text NOT NULL
          )'''
        );

        await database.execute(
          '''CREATE TABLE progress(
            id Text PRIMARY KEY NOT NULL,
            exerciseId TEXT NOT NULL,
            workoutList Text NOT NULL
          )'''
        );

        await database.execute(
          '''CREATE TABLE user(
            name Text PRIMARY KEY NOT NULL,
            bodyWeight Text NOT NULL
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