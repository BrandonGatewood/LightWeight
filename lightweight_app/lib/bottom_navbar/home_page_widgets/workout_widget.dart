import "package:flutter/material.dart";

class Workouts extends StatelessWidget {
  const Workouts({super.key});

    @override
  Widget build(BuildContext context) {
    //return planYourWorkoutsWidget(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Workouts'),
      ),
    );
  }
}