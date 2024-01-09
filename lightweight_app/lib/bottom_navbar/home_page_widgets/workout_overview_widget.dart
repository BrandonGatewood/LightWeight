import "package:flutter/material.dart";

class WorkoutOverview extends StatelessWidget {
  const WorkoutOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return planDummyData(context);
  }

  Widget planDummyData(BuildContext context) {
    return SizedBox(
        // SizedBox Styling 
        height: 350,
        child: ListView(
          children: workouts(),
        ),
      );
  }

  /*
    workouts will generate a list of the users workouts for the day.
  */
  List<Widget> workouts() {
    // find todays workouts
    List<Widget> workoutList = [];

    List<String> name = ['incline Bench', 'flat bench', 'incline dumbbell bench', 'seated flies', 'standing flies'];
    List<String> reps = ['4', '3', '4', '2', '3'];

    for(int i = 0; i < name.length; ++i) {
      workoutList.add(workoutCard(name[i], reps[i]));
    }
    return workoutList;
  }
  /*
    workoutCard generates a Generic workout card with the workout name 
    and the number of reps.
  */
  Card workoutCard(String title, String reps) {
    String sub = '$reps reps';
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(sub),
      ),
    );
  }
}