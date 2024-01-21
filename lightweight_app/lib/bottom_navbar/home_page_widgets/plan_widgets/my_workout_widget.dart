import 'dart:math';

import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/workout_db.dart';
import '../../../icons.dart';
import '../../../styles.dart';
import './select_exercises.dart';

enum workoutDialogPopupItems { rename, editExerciceList, delete }

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
                  largeDialog(workoutList[index]);
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


//    *** DIALOG FUNCTIONS ***

  /*
    failedDialog function is the layout dialog for a failed request with the database.

    The String passed in dialog, is used to determine what kind of failed request occurred.

    The failed response will display in the center of the dialog.
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
  
  void addWorkoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 215.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: addWorkoutDialogList(),              
          ),
        ),
      ),
    );

    _controller.clear();
  }

  /*
    miniDialog function is a sizedbox used for when small SizedBox's need to be used.

    functions that use miniDialog are addWorkoutDialog(), updateWorkoutDialog(), 
    deleteWorkoutDialog(), successDialog(), and failedDialog().
  */
  void miniDialog(int options, Workout aWorkout) {
    List<Widget> dialogList = <Widget>[];

    switch(options) {
      case 1:
        dialogList = updateWorkoutDialog(aWorkout);
        break;
      case 2:
        dialogList = deleteWorkoutDialog(aWorkout);
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
    largeDialog function is a sizedbox used for fowardArrowIcon on a workoutCard
    is pressed. This is where users will find all information on the workout. 

    edit workout name
    delete workout
    edit exercises
  */
  void largeDialog(Workout aWorkout) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 400.0,
          child: Column(
            children: workoutDialog(aWorkout),              
          ),
        ),
      ),
    );
  }


  // getExercises converts the String, exerciseList, to a List<String>
  List<String> getExercises(Workout aWorkout) {
    return aWorkout.exerciseList.split(';');
  }

  // getExerciseSets converts the String, setsList, to a List<String>
  List<String> getExerciseSets(Workout aWorkout) {
    return aWorkout.setsList.split(';');
  }

  List<Widget> workoutDialog(Workout aWorkout) {
    List<String> exerciseList = getExercises(aWorkout);

    return <Widget> [
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
    ];
  }
  
  PopupMenuButton<workoutDialogPopupItems> workoutDialogPopupMenu(Workout aWorkout) {
    workoutDialogPopupItems? selectedMenu;

    return PopupMenuButton<workoutDialogPopupItems>(
      initialValue: selectedMenu,
      // Callback that sets the selected popup menu item.
      onSelected: (workoutDialogPopupItems item) {
        setState(() {
          selectedMenu = item;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<workoutDialogPopupItems>>[
        PopupMenuItem<workoutDialogPopupItems>(
          value: workoutDialogPopupItems.rename,
          child: const Text('Rename workout',),
          onTap: () {
            miniDialog(1, aWorkout);
          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem<workoutDialogPopupItems>(
          value: workoutDialogPopupItems.editExerciceList,
          child: const Text('Edit exercises'),
          onTap: () {

          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem<workoutDialogPopupItems>(
          value: workoutDialogPopupItems.delete,
          child: const Text('Delete workout'),
          onTap: () {
            miniDialog(2, aWorkout);
          },
        ),
      ],
    );
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

  /*
    addworkoutDialog function is the layout dialog for adding a new workout into the database.
    It includes two buttons to exit and save, and a Textfield to enter a workout name.

    TextFields onSumitted attribute will navigate user to a new screen to select users exercises
    for that workout.
  */
  List<Widget> addWorkoutDialogList() {
    bool validated; 

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
    ];
  }

  /*
    updateWorkoutDialog function is the layout dialog for updating a workout in the database.
    It includes two buttons to exit and save, and a Textfield to update the workout name.
  */
  List<Widget> updateWorkoutDialog(Workout aWorkout) {
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
    DeleteWorkoutDialog function is the layout dialog for deleting a workout in the database.
    It includes two buttons to exit and save, and a Text Widget stating to confirm deletion of 
    the exercise.
  */ 
  List<Widget> deleteWorkoutDialog(Workout aWorkout) {
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
      Navigator.pop(context);
      _refreshWorkouts();
    }
    else {
      failedDialog(3);
    }
  }
}