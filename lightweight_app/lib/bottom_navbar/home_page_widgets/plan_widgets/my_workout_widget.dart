import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/workout_db.dart';
import '../../../icons.dart';
import '../../../styles.dart';
import './select_exercises.dart';

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

  void _refreshWorkouts() async {
    final data = await _dbHelper.getAllWorkouts();

    setState(() {
      workoutList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _dbHelper = WorkoutsDBHelper();
    _dbHelper.openWorkouts().whenComplete(() async {
      setState(() {
        _refreshWorkouts();
        setState(() {
        });
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
        title: const Text('My Workouts'),
        actions: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                miniDialog(0, '');
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

    Each workout is represented as a card, where the user can view more info about the workout. 
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
  SizedBox workoutCard(Workout aWorkout) {
    return SizedBox(
      height: 300,
      child: Column(children: <Widget>[
        Text(aWorkout.name),
        Text(aWorkout.exerciseList),
      ],)
    );
  }


//    *** DIALOG FUNCTIONS ***


  /*
    miniDialog function is a sizedbox used for when small SizedBox's need to be used.

    functions that use miniDialog are addWorkoutDialog(), updateWorkoutDialog(), 
    deleteWorkoutDialog(), successDialog(), and failedDialog().
  */
  void miniDialog(int options, String name) {
    List<Widget> dialogList = <Widget>[];

    switch(options) {
      case 0:
        dialogList = addWorkoutDialog();
        break;
      case 1:
        dialogList = updateWorkoutDialog(name);
        break;
      case 2:
        dialogList = deleteWorkoutDialog(name);
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
        insetPadding: EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 220.0,
          child: Column(
            children: dialogList,              
          ),
        ),
      ),
    );

    if(options == 1) {
      _refreshWorkouts();
    }
  }

  /*
    addworkoutDialog function is the layout dialog for adding a new workout into the database.
    It includes two buttons to exit and save, and a Textfield to enter a workout name.

    TextFields onSumitted attribute will navigate user to a new screen to select users exercises
    for that workout.
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
            'Add Workout',
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WorkoutSelectExercises(workoutName: value),
              ),
            );
            //onSubmitAdd();
            // Select exercises for this workout
            //Map<String, int> exerciseMap = workoutToMap()
            // String numOfSetsString = setsToString()
          },
          decoration: Styles().inputWorkoutName('Workout name'),
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WorkoutSelectExercises(workoutName: _controller.text),
                  ),
                );
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ];
  }

  /*
    updateWorkoutDialog function is the layout dialog for updating a workout in the database.
    It includes two buttons to exit and save, and a Textfield to update the workout name.
  */
  List<Widget> updateWorkoutDialog(String name) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Rename Workout',
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
            
            // Select exercises for this workout
            //Map<String, int> exerciseMap = workoutToMap()
            // String numOfSetsString = setsToString()
            //onSubmitAdd();
          },
          decoration: Styles().inputWorkoutName('new Workout name'),
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
                //onSubmitAdd();
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ];
  }
  /*
    DeleteWorkoutDialog function is the layout dialog for deleting a workout in the database.
    It includes two buttons to exit and save, and a Text Widget stating to confirm deletion of 
    the exercise.
  */ 
  List<Widget> deleteWorkoutDialog(String name) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Delete Workout',
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
          'Confirm to delete workout',
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
    successDialog function is the layout dialog for a successful request with the database.

    The String passed in dialog, is used to determine what kind of successful request occurred.

    The successful response will display in the center of the dialog.
  */
  List<Widget> successDialog(String selection) {
    String title = '';

    switch(selection) {
      case '0':
        title = 'Workout added to List.';
        break;
      case '1':
        title = 'Workout updated.';
        break;
      case '2':
        title = 'Workout deleted.';
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
      const Spacer(),
    ];
  }

  /*
    failedDialog function is the layout dialog for a failed request with the database.

    The String passed in dialog, is used to determine what kind of failed request occurred.

    The failed response will display in the center of the dialog.
  */
  List<Widget> failedDialog(String selection) {
    String title = '';
    String content = 'Workout already exists.';

    switch(selection) {
      case '0': 
        title = 'Failed to add workout.';
        break;
      case '1':
        title = 'Failed to update workout.';
        break;
      case '2':
        title = 'Failed to delete workout.';
        content = 'workout not found.';
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
    onSubmitUpdate function handles the users input with the TextEditingContoller class to
    get the users input and passes that as a parameter to update the workout in the 
    database.
  */
  void onSubmitUpdate(String name) async {
    bool update = await _dbHelper.updateWorkout(name, _controller.text);

    handleRequest(update, 1);
  }
  
  /*
    onSubmitDelete function handles the users input to delete a workout from the database.
  */
  void onSubmitDelete(String name) async {
    bool delete = await _dbHelper.deleteWorkout(name);

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
      miniDialog(4, selection.toString());
      _refreshWorkouts();
    }
    else {
      miniDialog(5, selection.toString());
    }
  }
}