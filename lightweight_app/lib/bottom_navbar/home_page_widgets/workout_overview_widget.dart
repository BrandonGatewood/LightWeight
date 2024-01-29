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
    double height = 65;
    // select height depending on workout length
    switch(todaysWorkout.exerciseList.length) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        height *= 2;
        break;
      case 3:
        height *= 3;
        break;
      case 4:
        height *= 4;
        break;
      case 5:
        height *= 5;
        break;
      default:
        height = 375;
        break;
    }

    return SizedBox(
      height: height,
      child: checkForRestDay(),
    );
  }

  Widget checkForRestDay() {
    if(todaysWorkout.id == 'RestDay') {
      return Center(
          child: Text(
            'Rest Day',
            style: Styles().largeDialogHeader(),
          ),
      );
    }
    else if(todaysWorkout.exerciseList.isEmpty) {
      return Center(
          child: Text(
            'No exercises in workout',
            style: Styles().largeDialogHeader(),
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
            child: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      todaysWorkout.exerciseList[index].name,
                      style: Styles().content(),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        sub,
                        style: Styles().subtitle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}