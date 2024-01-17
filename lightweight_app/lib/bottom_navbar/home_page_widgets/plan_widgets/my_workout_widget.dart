import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/workout_db.dart';
import '../../../icons.dart';
import '../../../db_helper/exercise_db.dart';

class Workouts extends StatefulWidget {
  const Workouts({super.key});

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  late TextEditingController _controller;
  late WorkoutsDBHelper _dbHelper;
  MyIcons icons = MyIcons();
  List<Workout> workoutList = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
        actions: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
              },
              icon: icons.addIcon(), 
            ),
          ),
        ],
      ),
      body: mainLayout(),
    );
  }


//    *** MAIN LAYOUT FUNCTIONS ***


/*
    mainLayout function returns the appropriate Widget depending on the users exercise list.

    If the users exercise list is empty, then it will return a Text widget stating that there
    are no exercies. Otherwise it will return a GridView of the users exercises. 

    Each exercise is represented as a card, where the user can view the exercise name. 
  */
  Widget mainLayout() {
    if(workoutList.isEmpty) {
      return const Center(
        child: Text(
          'No Workouts',
        )
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: workoutList.length,
          itemBuilder: (BuildContext context, int index) {
            return workoutCard(workoutList[index]);
          },
        ),
      );
    }
  }

  /*

  */
  Card workoutCard(Workout aWorkout) {
    return Card(
      child: Text('Workoutlist'),
    );
  }





  
}