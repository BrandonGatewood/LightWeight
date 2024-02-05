import 'package:flutter/material.dart';
import 'package:lightweight_app/db_helper/exercise_db.dart';

class ExerciseProgress extends StatelessWidget {
  const ExerciseProgress({
    super.key,
    required this.anExercise,
  });

  final Exercise anExercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(anExercise.name),
      ),
    );
  }
}