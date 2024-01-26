import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/workout_db.dart';
import 'package:lightweight_app/styles.dart';

class WorkoutOverview extends StatelessWidget {
  const WorkoutOverview({
    super.key,
    required this.todaysWorkout,
  });

  final Workout todaysWorkout;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: checkForRestDay(),
    );
  }

  Widget checkForRestDay() {
    if(todaysWorkout.id == 'RestDay') {
      return Center(
        child: Card(
          child: Text(
            'Rest Day',
            style: Styles().largeDialogHeader(),
          ),
        ),
      );
    }
    else {
      return ListView.builder(
        itemCount: todaysWorkout.exerciseList.length,
        itemBuilder: (BuildContext context, int index) {
          String num = todaysWorkout.setsList[index];
          String sub = '$num Sets';

          return Card(
            child: ListTile(
              title: Text(todaysWorkout.exerciseList[index].name),
              subtitle: Text(sub),
            ),
          );
        },
      );
    }
  }
}