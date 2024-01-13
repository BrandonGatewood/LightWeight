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