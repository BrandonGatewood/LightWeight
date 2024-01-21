import "package:flutter/material.dart";
import '../../../icons.dart';
import '../../../db_helper/exercise_db.dart';
import '../../../styles.dart';

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
          Padding(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              child: IconButton(
                onPressed: () {
                  addExerciseDialog();
                },
                icon: icons.addIcon(), 
              ),
            ),
          ),
        ],
      ),
      body: mainLayout(),
    );
  }


//        ***** MAIN LAYOUT FUNCTIONS *****

  /*
    mainLayout function handles the body of my_exercises_widget.

    If the user doesnt have any exercises in the database, then it will return
    a Text Widget stating no exercises

    Else the function will return a ListView Widget of all the exercises in the 
    database.
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
            return Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(exerciseList[index].name),
                    subtitle: Text(
                      'Max Weight: 140lbs',
                      style: Styles().subtitle()
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        dialog(0, exerciseList[index]);
                      },
                      icon: icons.forwardArrowIcon(),
                    ),
                  ),
                ],
              ),
            ); 
          },
        ),
      );
    }
  }


//        ***** DIALOG FUNCTIONS *****

  /*
    dialog function is an AlertDialog for each exerciseCard in the mainLayout. 
    This is where users can find and edit data on that exercise. 
    
    The Passed in int selects which List<Widget> to display in the AlertDialog
    to edit the Exercise object.
  */
  void dialog(int options, Exercise anExercise) {
    List<Widget> dialogList = <Widget>[];

    switch(options) {
      case 0:
        dialogList = editExerciseWidgetList(anExercise);
        break; 
      case 1:
        dialogList = deleteExerciseWidgetList(anExercise);
        break;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 210.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: dialogList,              
          ),
        ),
      ),
    );

    clearController();
  }

  /*
    addExerciseDialog function is an AlertDialog that lets users add a new 
    workout. 
  */ 
  void addExerciseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 210.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:  icons.backArrowIcon(),
                  ),
                  const Spacer(),
                  const Spacer(),
                  Text(
                    'Add Exercise',
                    style: Styles().dialogHeader(), 
                  ),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                  right: 10,
                  bottom: 5, 
                ),
                child: TextField(
                  maxLength: 28,
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
                    child: Styles().saveTextButton(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    clearController(); 
  }

  /*
    editExerciseDialogList function is the layout dialog for updating an exercise.
  */ 
  List<Widget> editExerciseWidgetList(Exercise anExercise) {
    return <Widget>[
      Row( 
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Edit Exercise',
            style: Styles().dialogHeader(), 
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              dialog(1, anExercise);
            }, 
            icon: icons.deleteIcon(),
          ),
        ],
      ),
      
      Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
          bottom: 5,
        ),
        child: TextField(
          maxLength: 28,
          controller: _controller,
          onSubmitted: (String value) async {
            onSubmitUpdate(anExercise.name);
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
                onSubmitUpdate(anExercise.name);
              }
            }, 
            child: Styles().saveTextButton(),
          ),
        ),
      ),
    ]; 
  }
  
  /*
    deleteExerciseDialogList function is the layout dialog for deleting an exercise in the database.
  */ 
  List<Widget> deleteExerciseWidgetList(Exercise anExercise) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          const Spacer(),
          Text(
            'Delete Exercise',
            style: Styles().dialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
          const Spacer(),
        ],
      ),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'Confirm to delete exercise',
          style: Styles().subtitle(), 
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
            radius: 25,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                onSubmitDelete(anExercise.name);
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ]; 
  }
  
  /*
    failedDialog function is an AlertDialog that alerts the user when theres a failed
    request with the database.  

    Future.delayed is ued to close the AlertDialog after 2 seconds.
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
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 210.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                  style: Styles().subtitle(),
                ),
              ),
              const Spacer(),
            ]
          ),
        ),
      ),
    );

    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.pop(context); 
      },
    );
  }


//        ***** ONSUBMIT FUNCTIONS DATABASE REQUESTS HELPER FUNCTIONS *****

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
  
  // onSubmitDelete function handles the users input to delete an exercise from the database.
  void onSubmitDelete(String name) async {
    await _dbHelper.deleteExercise(name);

    handleDeleteRequest();
  }

  /*
    handleRequest function is a helper function for all onSubmit functions. It will
    display the appropriate dialog.  

    When a request is successful, it will refresh the layout to keep up to date with the
    list.
  */
  void handleRequest(bool flag, int selection) {
    if(flag) {
      _refreshExercises();
      Navigator.popUntil(context, (route) => route.settings.name == '/exercises'); 
    }
    else {
      failedDialog(selection);
    }
  }

  // refresh users workoutList and popUntil mainLayout()
  void handleDeleteRequest() {
    _refreshExercises();
    Navigator.popUntil(context, (route) => route.settings.name == '/exercises'); 
  }
  
  // clearController clears the text in the TextEditingContoller _controller.
  void clearController() {
    if(_controller.text.isNotEmpty) {
      _controller.clear();
    }
  }
}