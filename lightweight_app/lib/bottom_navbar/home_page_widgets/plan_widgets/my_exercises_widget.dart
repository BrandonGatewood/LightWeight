import "package:flutter/material.dart";
import '../../../icons.dart';
import '../../../db_helper/exercise_db.dart';
import '../../../styles.dart';

// Enum for exercise card pop up menu
enum Menu {rename, deleteExercise}

class Exercises extends StatefulWidget {
  const Exercises({super.key});

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  late TextEditingController _controller;
  late ExerciseDBHelper _dbHelper;
  MyIcons icons = MyIcons();
  List<Exercise> exerciseList = [];

  void _refreshExercises() async {
    final data = await _dbHelper.getAllExercise();

    setState(() {
      exerciseList = data;
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
    are no exercies. Otherwise it will return a ListView of the users exercises. 

    Each exercise is represented as a card, where the user can view the exercise. 
  */
  Widget mainLayout() {
    if(exerciseList.isEmpty) {
      return const Center(
        child: Text(
          'No Exercises',
        )
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: exerciseList.length,
          itemBuilder: (BuildContext context, int index) {
            return exerciseCard(exerciseList[index]);
          },
        ),
      );
    }
  }

  /*
    exerciseCard function displays each exercise in a card with a ListTile
    to display information on the exercise.

    Each card displays the exercise name as the title, max weight as the subtitle.
    and a trailing IconButton to give user more options with the exercise.
  */ 
  Card exerciseCard(Exercise anExercise) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              anExercise.name,
              style: Styles().cardTitle(),
            ),
            subtitle: const Text('Max Weight: 140lbs'),
            trailing: IconButton(
              onPressed: () {
                dialog(2, anExercise.name);
              },
              icon: icons.forwardArrowIcon(),
            ),
          ),
        ],
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
      case 2:
        dialogList = editExerciseDialog(name);
        break; 
      case 3:
        dialogList = deleteExerciseDialog(name);
        break;
      case 4:
        dialogList = failedDialog(name);
        break;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 250.0,
          width: 300.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: dialogList,              
          ),
        ),
      ),
    );

    _controller.clear();

    // Success or failed dialog, so return to my_exercises
    if(options == 4) {
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
      Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon:  icons.backArrowIcon(),
        ),
      ),
      Text(
        'Add Exercise',
        style: Styles().dialogHeader(), 
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
          bottom: 5, 
        ),
        child: TextField(
          maxLength: 22,
          controller: _controller,
          onSubmitted: (String value) async {
            onSubmitAdd();
          },
          decoration: Styles().inputWorkoutName('Exercise name'),
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 10,
          ), 
          child: TextButton(
            onPressed: () {
              if(_controller.text.isNotEmpty) {
                onSubmitAdd();
              }
            }, 
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    ]; 
  }

  /*
    updateExerciseDialog function is the layout dialog for updating an exercise in the database.
    It includes two buttons to exit and save, and a Textfield to update an exercise name.
  */ 
  List<Widget> editExerciseDialog(String name) {
    return <Widget>[
      Row( 
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              dialog(3, name);
            }, 
            icon: icons.deleteIcon(),
          ),
        ],
      ),
      Text(
        'Edit Exercise',
        style: Styles().dialogHeader(), 
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
          bottom: 5,
        ),
        child: TextField(
          maxLength: 22,
          controller: _controller,
          onSubmitted: (String value) async {
            if(value.isNotEmpty) {
              onSubmitUpdate(name);
            }
          },
          decoration: Styles().inputWorkoutName('New exercise name'),
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 10,
          ), 
          child: TextButton(
            onPressed: () {
              if(_controller.text.isNotEmpty) {
                onSubmitUpdate(name);
              }
            }, 
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
              ),
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
            style: Styles().dialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
      const Spacer(),
      const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Confirm to delete Exercise',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      const Spacer(),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 10,
            bottom: 10,
          ), 
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                onSubmitDelete(name);
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
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
      const Spacer(),
      Center(
        child: Text(
          title,
          style: Styles().dialogHeader(),
        ),
      ),
      Center(
        child: Text(
          content,
        ),
      ),
      const Spacer(),
    ];
  }


//    *** ONSUBMIT FUNCTIONS AND DATABASE REQUESTS ***


  /*
    onSubmitAdd function handles the users input with the TextEditingContoller class to
    get the users input and passes that as a parameter to add a new exercise into the 
    database.
  */
  void onSubmitAdd() async {
    bool add = await _dbHelper.insertExercise(_controller.text);

    handleRequest(add, 0);
  }

  /*
    onSubmitUpdate function handles the users input with the TextEditingContoller class to
    get the users input and passes that as a parameter to update an exercise in the 
    database.
  */
  void onSubmitUpdate(String name) async {
    bool update = await _dbHelper.updateExercise(name, _controller.text);

    handleRequest(update, 1);
  }
  
  /*
    onSubmitDelete function handles the users input to delete an exercise from the database.
  */
  void onSubmitDelete(String name) async {
    bool delete = await _dbHelper.deleteExercise(name);

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
      _refreshExercises();
      Navigator.popUntil(context, (route) => route.settings.name == '/exercises'); 
    }
    else {
      dialog(4, selection.toString());
    }
  }
}