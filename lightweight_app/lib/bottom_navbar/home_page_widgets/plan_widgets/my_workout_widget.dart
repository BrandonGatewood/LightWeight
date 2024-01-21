import 'dart:math';

import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/workout_db.dart';
import '../../../icons.dart';
import '../../../styles.dart';
import './select_exercises.dart';

enum WorkoutDialogPopupItems { rename, editExerciceList, delete }

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
          Padding(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              child: IconButton(
                onPressed: () {
                  addWorkoutDialog();
                },
                icon: icons.addIcon(), 
              ),
            ),
          )
        ],
      ),
      body: mainLayout(),
    );
  }

  /*
    mainLayout function handles the body of my_workout_widget. 

    If the user doesnt have any workouts in the database then it will return a Text widget 
    stating no workouts.

    Else the function will return a ListView widget of all the workouts in the database.
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
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  workoutDialog(workoutList[index]);
                },
                  child: ListTile(
                    title: Text(workoutList[index].name),
                    trailing: icons.forwardArrowIcon(),
                  ),
              ),
            );
          },
        ),
      );
    }
  }


//        ***** DIALOG FUNCTIONS *****

  /*
    workoutDialog function is an AlertDialog for each workoutButtonCard. It is where
    the user can find information on that workout. User may also edit data on the workout.
  */
  void workoutDialog(Workout aWorkout) {
    List<String> exerciseList = getExercises(aWorkout);

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 400.0,
          child: Column(
            children: <Widget> [
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:  icons.backArrowIcon(),
                  ),
                  const Spacer(),
                  Text(
                    aWorkout.name,
                    style: Styles().largeDialogHeader(), 
                  ),
                  const Spacer(),
                  workoutDialogPopupMenu(aWorkout), 
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 12
                ),
                child: Divider(
                  thickness: 2,
                ),
              ),
              SizedBox(
                height: 300,
                width: 250,
                child: ListView.builder(
                  itemCount: exerciseList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            exerciseList[index],
                            style: Styles().content(),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
    addWorkoutDialog function is an AlertDialog that lets the user add a new workout. 
    It is the layout dialog for adding a new workout into the database.
  */
  void addWorkoutDialog() {
    bool validated;

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 215.0,
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
                  Text(
                    'Add Workout',
                    style: Styles().dialogHeader(), 
                  ),
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
                    validated = validateWorkoutName(value);

                    if(validated) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WorkoutSelectExercises(workoutName: value, workoutDb: _dbHelper,),
                        ),
                      ).then((value) => _refreshWorkouts());
                    }
                    else {
                      failedDialog(0);
                    }
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
                  child: TextButton(
                    onPressed: () {
                      if(_controller.text.isNotEmpty) {
                        validated = validateWorkoutName(_controller.text);

                        if(validated) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WorkoutSelectExercises(workoutName: _controller.text, workoutDb: _dbHelper,),
                            ),
                          ).then((value) => _refreshWorkouts());
                        }
                        else {
                          failedDialog(0);
                        }
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

    _controller.clear();
  }

  /*
    miniDialog function is an AlertDialog used when a user wants to update a workout
    or delete the workout.

    The passed in int is used to determine the appropriate Widget to display. Workout
    object is passed in to modify a workout.
  */
  void miniDialog(int options, Workout aWorkout) {
    List<Widget> dialogList = <Widget>[];

    switch(options) {
      case 1:
        dialogList = updateWorkoutDialogList(aWorkout);
        break;
      case 2:
        dialogList = deleteWorkoutDialogList(aWorkout);
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 215.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: dialogList,              
          ),
        ),
      ),
    );

    _controller.clear();
  }
  
  /*
    workoutDialogPopupMenu function is the button used in the workoutDialog to modify 
    the workout. 

    users may rename or delete the workout, and edit the exercises for that workout.
  */ 
  PopupMenuButton<WorkoutDialogPopupItems> workoutDialogPopupMenu(Workout aWorkout) {
    WorkoutDialogPopupItems? selectedMenu;

    return PopupMenuButton<WorkoutDialogPopupItems>(
      initialValue: selectedMenu,
      // Callback that sets the selected popup menu item.
      onSelected: (WorkoutDialogPopupItems item) {
        setState(() {
          selectedMenu = item;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<WorkoutDialogPopupItems>>[
        PopupMenuItem<WorkoutDialogPopupItems>(
          value: WorkoutDialogPopupItems.rename,
          child: const Text('Rename workout',),
          onTap: () {
            miniDialog(1, aWorkout);
          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem<WorkoutDialogPopupItems>(
          value: WorkoutDialogPopupItems.editExerciceList,
          child: const Text('Edit exercises'),
          onTap: () {

          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem<WorkoutDialogPopupItems>(
          value: WorkoutDialogPopupItems.delete,
          child: const Text('Delete workout'),
          onTap: () {
            miniDialog(2, aWorkout);
          },
        ),
      ],
    );
  }

  /*
    updateWorkoutDialogList function is the layout for updating a workout in the database.
  */
  List<Widget> updateWorkoutDialogList(Workout aWorkout) {
    bool validated;

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
            'Rename Workout',
            style: Styles().largeDialogHeader(), 
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
          controller: _controller,
          maxLength: 30, 
          onSubmitted: (String value) async {
            validated = validateWorkoutName(value);

            if(validated) {
              onSubmitUpdate(aWorkout.name);
            }
          },
          decoration: Styles().inputWorkoutName('New workout name'),
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
              validated = validateWorkoutName(_controller.text);

              if(validated) {
                onSubmitUpdate(aWorkout.name);
              }
            },
            child: Styles().saveTextButton(),
          ),
        ),
      ),
    ];
  }

  /*
    DeleteWorkoutDialog function is the layout for deleting a workout in the database.
  */ 
  List<Widget> deleteWorkoutDialogList(Workout aWorkout) {
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
                onSubmitDelete(aWorkout.name);
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ]; 
  }

  /*
    failedDialog function is an AlertDialog that alerts the user when theres a failed request
    when communicating with the database. The passed in int is used to determine the error.  

    Future.delayed is used to close the AlertDialog after 2 seconds.
  */
  void failedDialog(int selection) {
    String title = '';
    String content = 'Workout already exists.';

    switch(selection) {
      case 0: 
        title = 'Failed to add workout.';
        break;
      case 1:
        title = 'Failed to update workout.';
        break;
      case 2:
        title = 'Failed to delete workout.';
        content = 'workout not found.';
        break;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), 
        child: SizedBox(
          height: 215.0,
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
      Navigator.pop(context);
      _refreshWorkouts();
    }
    else {
      failedDialog(3);
    }
  }
  
  // getExercises converts the String, exerciseList, to a List<String>
  List<String> getExercises(Workout aWorkout) {
    return aWorkout.exerciseList.split(';');
  }

  // getExerciseSets converts the String, setsList, to a List<String>
  List<String> getExerciseSets(Workout aWorkout) {
    return aWorkout.setsList.split(';');
  } 
  
  /*
    validateWorkoutName function is called when adding a new Workout. It is
    called before selecting exercises to save time.

    returns true if new workout name is unique and false otherwise.
  */
  bool validateWorkoutName(String workoutName) {
    for(int i = 0; i < workoutList.length; ++i) {
      if(workoutName == workoutList[i].name) {
        return false;
      }
    }

    return true;
  }
}