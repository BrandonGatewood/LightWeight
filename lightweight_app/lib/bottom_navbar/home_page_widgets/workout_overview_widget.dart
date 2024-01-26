import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/current_split_db.dart';
import 'package:lightweight_app/styles.dart';

class WorkoutOverview extends StatefulWidget {
  const WorkoutOverview({super.key});

  @override
  State<WorkoutOverview> createState() => _WorkoutOverviewState();
}

class _WorkoutOverviewState extends State<WorkoutOverview> {
  late CurrentSplitDBHelper currentSplitDb;
  late CurrentSplit todaysWorkout;
  int todayIndex = DateTime.now().weekday - 1; 


  @override
  void initState() {
    super.initState();
    todaysWorkout = CurrentSplit();
    currentSplitDb = CurrentSplitDBHelper();
    currentSplitDb.openCurrentSplit().whenComplete(() async {
      final CurrentSplit data = await currentSplitDb.getCurrentSplit();
      setState(() {
        todaysWorkout = data;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: checkForRestDay(),
    );
  }

  Widget checkForRestDay() {
    if(todaysWorkout.workoutList[todayIndex].id == 'RestDay') {
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
        itemCount: todaysWorkout.workoutList[todayIndex].exerciseList.length,
        itemBuilder: (BuildContext context, int index) {
          String num = todaysWorkout.workoutList[todayIndex].setsList[index];
          String sub = '$num Reps';

          return Card(
            child: ListTile(
              title: Text(todaysWorkout.workoutList[todayIndex].exerciseList[index].name),
              subtitle: Text(sub),
            ),
          );
        },
      );
    }
  }
}