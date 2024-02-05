import 'package:flutter/material.dart';
import 'package:lightweight_app/assets/styles.dart';
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
      body: Column(
        children: <Widget>[
          maxWeightAndReps(context),
        ],
      ),
    );
  }

  Padding maxWeightAndReps(BuildContext context) {
    int maxWeight = anExercise.maxWeight;
    int maxWeightReps = anExercise.maxWeightReps;
    int maxReps = anExercise.maxReps;
    int maxRepsWeight = anExercise.maxRepsWeight;

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: maxCard(context, 'Max Weight', '$maxWeight lbs for $maxWeightReps reps'),
          ),
          const Padding(
            padding: EdgeInsets.all(5),
          ),
          Expanded(
            child: maxCard(context, 'Max Reps', '$maxReps reps for $maxRepsWeight lbs'),
          ),
        ],
      ),
    );
  }

  Card maxCard(BuildContext context, String title, String content) {
    return Card( 
      elevation: 0,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Styles().cardTitle(),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  content,
                  style: Styles().content(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}