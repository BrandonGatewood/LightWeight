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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Exercises'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              const flag = [(true, '')];

              exerciseForm(context, _controller, flag);
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


// Forms and AlertDialogs


  /*
    Exercise form used for both adding a new exercise and updating an existing exercise
  */
  void exerciseForm(BuildContext context, TextEditingController textController, List<(bool, String)> flag) {
    String name = 'Exercise name';

    // flag is false, updating exercise
    if(!flag.first.$1) {
      name = 'New exercise name';
    }

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
                  if(value.isNotEmpty) {
                    if(flag.first.$1) {
                      addExercise(context, _controller);
                    }
                    else {
                      updateExercise(flag.first.$2, value);
                    }
                  }

                  Navigator.popUntil(context, (route) => route.settings.name == '/exercises'); 
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: name,
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              const Spacer(),
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
                  if(_controller.text.isNotEmpty) {
                    if(flag.first.$1) {
                    addExercise(context, _controller);
                    }
                    else {
                      updateExercise(_controller.text, flag.first.$2);
                    }
                  }
                  Navigator.popUntil(context, (route) => route.settings.name == '/exercises'); 
                },
                child: const Text('Save'),
              ),
              const Spacer(),
            ],
          ),
        ],
      )
    );
  }

  /*
    Exercise card used to display an exercise and give the user a option
    to delete or edit the exercise 
  */
  SizedBox exerciseCard(String name) {
    return SizedBox( 
      height: 70,
      child: Card(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10), 
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                final flag = [(false, name)];
                exerciseForm(context, _controller, flag);
              }, 
              icon: const Icon(Icons.edit_rounded,
                color: Colors.white, 
              ),
            ),
            IconButton(
              onPressed: () {
                confirmDeleteDialog(name);
              },
              icon: const Icon(Icons.delete_forever_rounded,
                color: Colors.white, 
              ),
            ),
          ],
        ),
      ),
    );
  }

/*
  Alertdialog to confirm deletion of an exercise
*/
  void confirmDeleteDialog(String name) {
    showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        content: Text('Are you sure you want to delete $name?'),
        actions: <Widget>[
          Row(
            children: <Widget>[
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  deleteExercise(name);
                  Navigator.popUntil(context, (route) => route.settings.name == '/exercises'); 
                },
                child: const Text('OK'),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  /*
    Generic AlertDialog to notify user on a failed action
  */
  void failedDialog(int selection) {
    String title = '';
    String content = 'Exercise already exists.';

    switch(selection) {
      case 0: 
        title = 'Failed to add exercise.';
        break;
      case 1:
        title = 'Failed to update exercise.';
        break;
      case 2:
        title = 'Failed to delete exercise.';
        content = 'Exercise not found.';
        break;
    }
    showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        title: Center(
          child: Text(title),
        ),
        content: Text(content),
      ),
    );
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.popUntil(context, (route) => route.settings.name == '/exercises'); 
      },
    );
  }

  /*
    Generic AlertDialog to notify user on successful action 
  */
  void successDialog(int selection) {
    String title = '';

    switch(selection) {
      case 0:
        title = 'Exercise added to List.';
        break;
      case 1:
        title = 'Exercise updated.';
        break;
      case 2:
        title = 'Exercise deleted.';
        break;
    }
    showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        title: Center(
          child: Text(title),
        ),
      ),
    );
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.popUntil(context, (route) => route.settings.name == '/exercises'); 
      },
    );
  }


// Communication with database


  /*
    add an exercise to the database
  */
  void addExercise(BuildContext context, TextEditingController _controller) async {
    String name = _controller.text;
    _controller.clear();

    // open db
    bool add = await _dbHelper.insertExercise(name);

    if(add) {
      successDialog(0);
      // refresh exercise list to keep it updated
      _refreshExercises();
    }
    else {
      failedDialog(0);
    }
  }

  /* 
    get all exercises from the database
  */
  Future<List<Widget>> getExercises() async {
    List<Widget> cardList = [];
    List<Exercise> myList = await _dbHelper.getAllExercise();

    for(int i = 0; i < myList.length; ++i) {
      cardList.add(exerciseCard(myList[i].name));
    }

    return cardList;
  }

  /*
    Update an Exercise 
  */
  void updateExercise(String name, String newName) async {
    _controller.clear();
    bool update = await _dbHelper.updateExercise(name, newName);

    if(!update) {
      failedDialog(1);
    }
    else {
      successDialog(1);
      _refreshExercises();
    }
  }

  /*
    delete an Exercise
  */
  void deleteExercise(String name) async {
    bool del = await _dbHelper.deleteItem(name);

    if(!del) {
      failedDialog(2);
    }
    else {
      successDialog(2);
      _refreshExercises();
    }
  }
}