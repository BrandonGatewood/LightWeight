import "package:flutter/material.dart";
import 'package:lightweight_app/charts/body_weight_chart.dart';
import 'package:lightweight_app/charts/exercise_chart.dart';
import 'package:lightweight_app/db_helper/user_db.dart';
import 'package:lightweight_app/db_helper/workout_db.dart';

class Highlight extends StatefulWidget {
  const Highlight({
    super.key,
    required this.aUser,
    required this.aWorkout,
  });

  final User aUser;
  final Workout aWorkout;

  @override
  State<Highlight> createState() => _Highlight(); 
}

class _Highlight extends State<Highlight> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      child: Column(
        children: <Widget>[
          BodyWeightChart(aUser: widget.aUser,),
          ExerciseChart(aWorkout: widget.aWorkout),
        ],
      )
    );
   
  }
}