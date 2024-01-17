import "package:flutter/material.dart";
import '../../../icons.dart';
import '../../../db_helper/exercise_db.dart';

class Exercises extends StatefulWidget {
  const Exercises({super.key});

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  late TextEditingController _controller;
  late ExerciseDBHelper _dbHelper;
  MyIcons icons = MyIcons();
  List<Exercise> workoutList = [];

  void _refreshExercises() async {
    final data = await _dbHelper.getAllExercise();

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
    MyIcons icons = MyIcons();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Exercises'),
        actions: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                dialog(0, '');
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
          'No Exercises.',
        )
      );
    }
    else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 8.0, // Spacing between columns
          mainAxisSpacing: 8.0, // Spacing between rows
        ),
        itemCount: workoutList.length,
        itemBuilder: (BuildContext context, int index) {
          return exerciseCard(workoutList[index]);
        },
      );
    }
  }
  
 SizedBox exerciseCard(Exercise anExercise) {
    return SizedBox( 
      height: 70,
      child: Card(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  dialog(1, anExercise.name);
                },
                icon: icons.forwardArrowIcon(),
              )
            ),
            Row(
              children: <Widget>[
                const Spacer(),
                Text(
                  anExercise.name,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const Text('Max Weight'),
            const Text('Max Reps'),
          ],
        ),
      ), 
    );
  }


//    *** DIALOG FUNCTIONS ***


  /*
    dialog function selects the appropriate dialog to display. Each selection returns a
    List<Widget> to display as children for the Column widget in ShowDialog().
  */
  void dialog(int options, String name) {
    List<Widget> dialogList = <Widget>[];

    switch(options) {
      case 0: 
        dialogList = addExerciseDialog();
        break;
      case 1:
        dialogList = exerciseDialog(name);
        break; 
      case 2:
        dialogList = updateExerciseDialog(name);
        break; 
      case 3:
        dialogList = deleteExerciseDialog(name);
        break;
      case 4:
        dialogList = successDialog(name);
        break;
      case 5:
        dialogList = failedDialog(name);
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

    // Success or failed dialog, so return to my_exercises
    if(options == 4 || options == 5) {
      Future.delayed(
        const Duration(seconds: 2),
        () {
          Navigator.popUntil(context, (route) => route.settings.name == '/exercises'); 
        },
      );
    }
  }

  /*
    addExerciseDialog function is the layout dialog for adding a new exercise into the database.
    It includes two buttons to exit and save, and a Textfield to enter an exercise name.
  */ 
  List<Widget> addExerciseDialog() {
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
            style: dialogHeader(), 
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
            onSubmitAdd();
          },
          decoration: inputWorkoutName('Exercise name'),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 20,
          ), 
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                onSubmitAdd();
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ]; 
  }

  /*
    exerciseDialog function is the layout dialog for an exercise. It includes a button to exit,
    and a popup menu that allows users to edit the exercise name and delete the exercise. This
    function also gets the exercises stats from the database to display.
  */
  List<Widget> exerciseDialog(String name) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            name,
            style: dialogHeader(), 
          ),
          const Spacer(),
          // popupmenu
          // updateDialog
          // deleteDialog
          const Spacer(),
        ],
      ),
      const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Max Weight: 140lbs x 8reps'),
      ),
      const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Max Reps: 12reps x 100lbs'),
      ),
    ]; 
  }

  /*
    updateExerciseDialog function is the layout dialog for updating an exercise in the database.
    It includes two buttons to exit and save, and a Textfield to update an exercise name.
  */ 
  List<Widget> updateExerciseDialog(String name) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Rename Exercise',
            style: dialogHeader(), 
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
            onSubmitUpdate(name);
          },
          decoration: inputWorkoutName('New exercise name'),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 20,
          ), 
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                onSubmitUpdate(name);
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ]; 
  }
  
  /*
    DeleteExerciseDialog function is the layout dialog for deleting an exercise in the database.
    It includes two buttons to exit and save, and a Text Widget stating to confirm deletion of 
    the exercise.
  */ 
  List<Widget> deleteExerciseDialog(String name) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Delete Exercise',
            style: dialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
      const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Confirm to delete Exercise',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 20,
          ), 
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                onSubmitUpdate(name);
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ]; 
  }
  
  /*
    successDialog function is the layout dialog for a successful request with the database.

    The String passed in dialog, is used to determine what kind of successful request occurred.

    The successful response will display in the center of the dialog.
  */
  List<Widget> successDialog(String selection) {
    String title = '';

    switch(selection) {
      case '0':
        title = 'Exercise added to List.';
        break;
      case '1':
        title = 'Exercise updated.';
        break;
      case '2':
        title = 'Exercise deleted.';
        break;
    }

    return <Widget>[
      Center(child: Text(title),),
    ];
  }

  /*
    failedDialog function is the layout dialog for a failed request with the database.

    The String passed in dialog, is used to determine what kind of failed request occurred.

    The failed response will display in the center of the dialog.
  */
  List<Widget> failedDialog(String selection) {
    String title = '';
    String content = 'Exercise already exists.';

    switch(selection) {
      case '0': 
        title = 'Failed to add exercise.';
        break;
      case '1':
        title = 'Failed to update exercise.';
        break;
      case '2':
        title = 'Failed to delete exercise.';
        content = 'Exercise not found.';
        break;
    }
    return <Widget>[
      Center(child: Text(title),),
      Center(child: Text(content)),
    ];
  }


//    *** ONSUBMIT FUNCTIONS AND DATABASE INTERACTION ***


  /*
    onSubmitAdd function handles the users input with the TextEditingContoller class to
    get the users input and passes that as a parameter to add a new exercise into the 
    database.

    If add was successful, then it will call successDialog() and refresh the exercise
    list to stay up to date.

    If add was unsuccessful, then it will call failedDialog(). 
  */
  void onSubmitAdd() async {
    bool add = await _dbHelper.insertExercise(_controller.text);

    handleRequest(add, 0);
  }

  /*
    onSubmitUpdate function handles the users input with the TextEditingContoller class to
    get the users input and passes that as a parameter to update an exercise in the 
    database.

    If update was successful, then it will call successDialog() and refresh the exercise
    list to stay up to date.

    If update was unsuccessful, then it will call failedDialog(). 
  */
  void onSubmitUpdate(String name) async {
    bool update = await _dbHelper.updateExercise(name, _controller.text);

    handleRequest(update, 1);
  }
  
  /*
    onSubmitDelete function handles the users input to delete an exercise from the database.

    If update was successful, then it will call successDialog() and refresh the exercise
    list to stay up to date.

    If update was unsuccessful, then it will call failedDialog(). 
  */
  void onSubmitDelete(String name) async {
    bool delete = await _dbHelper.deleteItem(name);

    handleRequest(delete, 2);
  }

  /*
    handleRequest function is a helper function for all onSubmit functions. It will clear
    the TextEditingController and display the appropriate dialog. Whether a request was
    successful or not. 

    When a request is successful, it will refresh the layout to keep up to date with the
    list.
  */
  void handleRequest(bool flag, int selection) {
    _controller.clear();

    if(flag) {
      dialog(4, selection.toString());
      _refreshExercises();
    }
    else {
      dialog(4, selection.toString());
    }
  }


//    *** STYLES AND DECORATIONS ***


 /*
    Styles for headers, textfields ...
  */
  // Textstyle for dialog headers
  TextStyle dialogHeader() {
    return const TextStyle(
      fontSize: 20,
    );
  }

  // InputDecoration for TextField
  InputDecoration inputWorkoutName(String name) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: name
    );
  } 
}


/*

Sill need:
  fix how dialog texts look
  implement popupmenu in exercisecard
    deletedialog
    update dialog
  check to see if _refresh function works

  test everything




*/