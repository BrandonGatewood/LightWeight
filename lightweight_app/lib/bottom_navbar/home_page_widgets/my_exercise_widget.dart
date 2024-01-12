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

  void _refreshExercises() async {
    final data = await getExercises();

    setState(() {
      workoutList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _dbHelper = ExerciseDBHelper();
    _dbHelper.openExercise().whenComplete(() async {
      _refreshExercises();
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    Add an exercise form
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
                  addExercise(context, _controller);
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
                  addExercise(context, _controller);
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
    Exercise card used to display an exercise and give the user and option
    to delete or edit the exercise 
  */
  Card exerciseCard(String name) {
    return Card(
      child: Row(
        children: <Widget>[
          Text(name),
          const Spacer(),
          IconButton(
            onPressed: () {
              updateExercise(name);
            }, 
            icon: const Icon(Icons.arrow_forward_ios_rounded,
              color: Colors.white, 
            ),
          ),
          IconButton(
            onPressed: () {
              deleteExercise(name);
            },
            icon: const Icon(Icons.delete_forever_rounded,
              color: Colors.white, 
            ),
          ),
        ],
      ),
    );
  }

  void failedDialog(int selection) {
    String title = '';
    String content = 'Exercise not found';

    switch(selection) {
      case 0: 
        title = 'Failed to add new exercise';
        content = 'Exercise already exists';
        break;
      case 1:
        title = 'Failed to update exercise';
        break;
      case 2:
        title = 'Failed to delete exercise';
        break;
    }
    showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
      ),
    );
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.pop(context);
      },
    );
  }

  /*
    add an exercise to the database
  */
  void addExercise(BuildContext context, TextEditingController _controller) async {
    String name = _controller.text;
    _controller.clear();

    // open db
    bool add = await _dbHelper.insertExercise(name);

    if(add) {
      // refresh exercise list to keep it updated
      _refreshExercises();
    }
    else {
      failedDialog(0);
    }
  }

  // get all exercises from the database
  Future<List<Widget>> getExercises() async {
    List<Widget> cardList = [];
    List<Exercise> myList = await _dbHelper.getAllExercise();

    for(int i = 0; i < myList.length; ++i) {
      cardList.add(exerciseCard(myList[i].name));
    }

    return cardList;
  }

  // Update an Exercise 
  void updateExercise(String name) async {
    bool update = await _dbHelper.updateExercise(name, 'It works');

    if(!update) {
      failedDialog(1);
    }
    else {
      _refreshExercises();
    }
  }
  // delete an Exercise
  void deleteExercise(String name) async {
    bool del = await _dbHelper.deleteItem(name);

    if(!del) {
      failedDialog(2);
    }
    else {
      _refreshExercises();
    }
  }
}