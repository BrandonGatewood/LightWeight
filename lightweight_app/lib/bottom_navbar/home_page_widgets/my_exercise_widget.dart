import "package:flutter/material.dart";
import '../../db_helper/exercise_db.dart';

class Exercises extends StatefulWidget {
  const Exercises({super.key});

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  late TextEditingController _controller;
  late ExerciseDBHelper _dbHelper;

  List<Widget> workoutList = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _dbHelper = ExerciseDBHelper();
    _dbHelper.openExercise().whenComplete(() async {
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getExercises();
    //return planYourWorkoutsWidget(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Exercises'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              addExerciseForm(context, _controller);
            }, 
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 30,
            ),
          ),
        ],
      ),
      body: ListView(
        children: workoutList,
      ),
    );
  }

  /*
    addExerciseWidget will display an AlertDialog widget with a form to fill out an
    exercise. 
  */
  void addExerciseForm(BuildContext context, TextEditingController _controller) {
    showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: SizedBox(
              height: 60,
              child: TextField(
                controller: _controller,
                onSubmitted: (String value) async {
                  addExerciseData(context, _controller);
                  Navigator.popUntil(context, (route) => route.settings.name == '/exercises'); 
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Exercise name',
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _controller.clear();
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text('Cancel'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  addExerciseData(context, _controller);
                  Navigator.popUntil(context, (route) => route.settings.name == '/exercises'); 
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      )
    );
  }

  /*
    SaveexerciseData function will talk with  
    to add a new exercise into the sqlite database.
  */
  void addExerciseData(BuildContext context, TextEditingController _controller) async {
    String name = _controller.text;
    _controller.clear();

    // open db
    await _dbHelper.insertExercise(name);
  }

  Future<void> getExercises() async {
    List<Exercise> myList = await _dbHelper.getAllExercise();

    for(int i = 0; i < myList.length; ++i) {
      workoutList.add(workoutCard(myList[i]));
    }
  }
  /*
    workoutCard generates a Generic workout card with the workout name 
    and the number of reps.
  */
  Card workoutCard(Exercise anExercise) {
    return Card(
      child: ListTile(
        title: Text(anExercise.name),
      ),
    );
  }
}