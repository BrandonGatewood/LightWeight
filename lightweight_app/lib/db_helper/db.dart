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
          name Text PRIMARY KEY NOT NULL,
          numOfTimesEntered INTEGER NOT NULL
          )'''
        );

        await database.execute(
          '''CREATE TABLE workouts(
            name Text PRIMARY KEY NOT NULL,
            exerciseList Text NOT NULL,
            numOfSets Text NOT NULL
          )'''
        );

        await database.execute(
          '''CREATE TABLE currentSplit(
            name Text PRIMARY KEY NOT NULL,
            workoutList Text NOT NULL
          )'''
        );

        await database.execute(
          '''CREATE TABLE progress(
            name Text PRIMARY KEY NOT NULL,
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
}