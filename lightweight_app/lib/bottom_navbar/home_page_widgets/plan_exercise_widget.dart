import "package:flutter/material.dart";

class Exercises extends StatelessWidget {
  const Exercises({super.key});

    @override
  Widget build(BuildContext context) {
    //return planYourWorkoutsWidget(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Exercises'),
      ),
      body: ListView(
        children: getExercises(),
      ),
    );
  }

  List<Widget> getExercises() {
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