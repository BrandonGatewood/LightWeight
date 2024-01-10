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
    );
  }
}