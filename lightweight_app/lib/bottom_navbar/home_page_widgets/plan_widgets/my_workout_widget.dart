import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/workout_db.dart';
import 'package:lightweight_app/db_helper/exercise_db.dart';
import '../../../icons.dart';
import '../../../styles.dart';

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
                miniDialog(0);
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
    mainLayout function returns the appropriate Widget depending on the users workout list.

    If the users workout list is empty, then it will return a Text widget stating that there
    are no workouts. Otherwise it will return a ListView of the users workouts. 

    Each workout is represented as a card, where the user can view the workout. 
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
    workoutCard function displays each workout in a card with a ListTile
    to display information on the workout. 

    Each card displays the exercise name as the title, max weight as the subtitle.
    and a trailing IconButton to give user more options with the exercise.
  */ 
  Card workoutCard(Workout aWorkout) {
    return Card(
      child: Text('Workoutlist'),
    );
  }


//    *** DIALOG FUNCTIONS ***


  /*

  */
  void miniDialog(int options) {
    List<Widget> dialogList = <Widget>[];

    switch(options) {
      case 0:
        dialogList = addWorkoutDialog();
        break;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 220.0,
          width: 300.0,
          child: Column(
            children: dialogList,              
          ),
        ),
      ),
    );
  }

  /*

  */
  List<Widget> addWorkoutDialog() {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Add Exercise',
            style: Styles().dialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: _controller,
          onSubmitted: (String value) async {
          },
          decoration: Styles().inputWorkoutName('Exercise name'),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 10,
          ), 
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ];
  }

//    *** ONSUBMIT FUNCTIONS AND DATABASE REQUESTS ***


  /*

  */
  
}