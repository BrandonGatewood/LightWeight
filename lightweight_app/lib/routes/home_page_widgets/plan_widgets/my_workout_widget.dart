import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/current_split_db.dart';
import 'package:lightweight_app/db_helper/workout_db.dart';
import 'package:lightweight_app/routes/home_page_widgets/plan_widgets/select_exercises.dart';
import 'package:lightweight_app/assets/icons.dart';
import 'package:lightweight_app/assets/styles.dart';

enum WorkoutDialogPopupItems { rename, editExerciceList, delete }

class Workouts extends StatefulWidget {
  const Workouts({
    super.key,
    required this.callbackCurrentSplit,
    required this.currentSplitDb,
  });

  final Function callbackCurrentSplit;
  final CurrentSplitDBHelper currentSplitDb;

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  late TextEditingController _controller;
  late WorkoutsDBHelper _dbHelper;

  MyIcons icons = MyIcons();
  List<Workout> allWorkoutList = [];

  void _refreshWorkouts() async {
    final data = await _dbHelper.getAllWorkouts();

    setState(() {
      allWorkoutList = data;
      widget.callbackCurrentSplit();
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
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              child: IconButton(
                onPressed: () {
                  addWorkoutDialog();
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

  /*
    mainLayout function handles the body of my_workout_widget. 

    If the user doesnt have any workouts in the database then it will return a Text widget 
    stating no workouts.

    Else the function will return a ListView widget of all the workouts in the database.
  */
  Widget mainLayout() {
    if(allWorkoutList.isEmpty) {
      return const Center(
        child: Text(
          'No Workouts',
        ),
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: allWorkoutList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: Styles().listViewPadding(),
              child: Dismissible(
                key: Key(allWorkoutList[index].id),
                direction: DismissDirection.endToStart,
                background: Styles().deleteButtonCardBackground(),
                confirmDismiss: (direction) async {
                  bool dismiss = confirmDeleteDialog(allWorkoutList[index]);
                  return dismiss;
                },
                child: ElevatedButton(
                  style: Styles().listViewButtonStyle(), 
                  onPressed: () {
                    workoutDialog(allWorkoutList[index]);
                  },
                  child: ListTile(
                    title: Text(allWorkoutList[index].name),
                    trailing: icons.forwardArrowIcon(),
                  ),
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
    workoutDialog function is an AlertDialog for each workoutButtonCard in the mainLayout. 
    This is where users can find and edit data of that Workout object. 

    The passed in Workout is used to edit data on that object.
  */
  void workoutDialog(Workout aWorkout) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SingleChildScrollView(
          child: SizedBox(
            height: 550.0,
            child: Column(
              children: <Widget> [
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.settings.name == '/workouts'),
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
                  height: 450,
                  width: 300,
                  child: ListView.builder(
                    itemCount: aWorkout.exerciseList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String sets = aWorkout.setsList[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  aWorkout.exerciseList[index].name,
                                  style: Styles().content(),
                                ),
                                const Spacer(),
                                Text(
                                  '$sets Sets',
                                  style: Styles().content(),
                                ),
                              ],
                            ),
                          ),
                          if(aWorkout.exerciseList.isNotEmpty)
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
      ),
    );
  }

  /*
    addWorkoutDialog function is an AlertDialog that lets the user add a new workout. 
  */
  void addWorkoutDialog() {
    bool validated;

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 240.0,
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
                    'Add Workout',
                    style: Styles().largeDialogHeader(), 
                  ),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
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
                    if(_controller.text.isNotEmpty) {
                      validated = validateWorkoutName(value);

                      if(validated) {
                        onSubmitAdd();
                      }
                      else {
                        failedDialog(0);
                      }
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
                          onSubmitAdd();
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
          height: 240.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: dialogList,              
          ),
        ),
      ),
    );

    clearController();
  }
  
  bool confirmDeleteDialog(Workout aWorkout) {
    bool dismiss = false;
    String name = aWorkout.name;

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 240.0,
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
                    'Delete Workout',
                    style: Styles().largeDialogHeader(), 
                  ),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
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
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Confirm to delete $name',
                  style: Styles().dialogHeader(),
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
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                    child: IconButton(
                      onPressed: () {
                        dismiss = true;
                        onSubmitDelete(aWorkout.id);
                      },
                      icon: icons.checkIcon(), 
                    ),
                  ),
                ),
              ),
            ] 
          ),
        ),
      ),
    );

    return dismiss;
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WorkoutSelectExercises(workout: aWorkout, workoutDb: _dbHelper,),
                settings: const RouteSettings(name: '/select_exercises'),
              ),
            ).then((value) => onSubmitUpdateExercises(aWorkout));
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
      Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
          bottom: 5,
        ),
        child: TextField(
          controller: _controller,
          maxLength: 20, 
          onSubmitted: (String value) async {
            if(_controller.text.isNotEmpty) {
              onSubmitUpdateName(aWorkout);
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
              if(_controller.text.isNotEmpty) {
                onSubmitUpdateName(aWorkout);
              }
            },
            child: Styles().saveTextButton(),
          ),
        ),
      ),
    ];
  }

  /*
    deleteWorkoutDialogList function is the layout for deleting a workout in the database.
  */ 
  List<Widget> deleteWorkoutDialogList(Workout aWorkout) {
    String name = aWorkout.name;

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
            'Delete Workout',
            style: Styles().largeDialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
          const Spacer(),
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
      const Spacer(),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Confirm to delete $name',
          style: Styles().dialogHeader(),
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
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                onSubmitDelete(aWorkout.id);
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
    when communicating with the database.

    Future.delayed is used to close the AlertDialog after 2 seconds.
  */
  void failedDialog(int selection) {
    String title = '';
    String content = 'Workout already exists.';

    switch(selection) {
      case 0: 
        title = 'Failed to Add Workout';
        break;
      case 1:
        title = 'Failed to Update Workout';
        break;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), 
        child: SizedBox(
          height: 240.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                child: Text(
                  title,
                  style: Styles().largeDialogHeader(),
                ),
              ),
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
              const Spacer(),
              Center(
                child: Text(
                  content,
                  style: Styles().dialogHeader(),
                ),
              ),
              const Spacer(),
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


  // Communicated with database to update a workout 
  void onSubmitAdd() async {
    bool add = await _dbHelper.insertWorkout(_controller.text);
    Workout newWorkout = await _dbHelper.getWorkoutByName(_controller.text); 

    handleAddRequest(add, newWorkout);
  }

  // Handles the state after attempting to update a workout
  void handleAddRequest(bool flag, Workout newWorkout) {
    if(flag) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WorkoutSelectExercises(workout: newWorkout, workoutDb: _dbHelper,),
          settings: const RouteSettings(name: '/select_exercises')
        ),
      ).then((value) {
        _refreshWorkouts();
        Navigator.popUntil(context, (route) => route.settings.name == '/workouts');
      });
    }
    else {
      failedDialog(0);
    }
  }
  
  // Communicated with database to update a workout 
  void onSubmitUpdateName(Workout aWorkout) async {
    if(validateWorkoutName(aWorkout.name)) {
      await _dbHelper.updateWorkoutName(aWorkout.id, _controller.text);
      handleUpdateNameRequest();

      Workout updatedWorkout = await _dbHelper.getWorkoutById(aWorkout.id);

      workoutDialog(updatedWorkout);
    }
    else {
      failedDialog(1);
    }
  }

  // Handles the state after attempting to update a workout
  void handleUpdateNameRequest() {
      _refreshWorkouts();
      Navigator.popUntil(context, (route) => route.settings.name == '/workouts');
  }

  // Communicated with database to update a workouts exerciseList
  void onSubmitUpdateExercises(Workout aWorkout) async {
    _refreshWorkouts();
    Workout? updatedWorkout = await _dbHelper.getWorkoutById(aWorkout.id);

    handleUpdateExercisesRequest();

    if(updatedWorkout != null) {
      workoutDialog(updatedWorkout);
    }
  }

  // Handles the state after attempting to update a workout
  void handleUpdateExercisesRequest() {
    _refreshWorkouts();
    Navigator.popUntil(context, (route) => route.settings.name == '/workouts');
  }

  // Communicated with database to delete a workout 
  void onSubmitDelete(String id) async {
    await _dbHelper.deleteWorkout(id);

    handleDeleteRequest();
  }

  // Handles the state after deleting a workout
  void handleDeleteRequest() {
    _refreshWorkouts();
    Navigator.popUntil(context, (route) => route.settings.name == '/workouts');
  }

  // Check whether or not a workout name already exists..
  bool validateWorkoutName(String workoutName) {
    for(final workout in allWorkoutList) {
      if(workout.name == workoutName) {
        return false;
      }
    }

    return true;
  }

  // clearController clears the text in the TextEditingContoller _controller.
  void clearController() {
    if(_controller.text.isNotEmpty) {
      _controller.clear();
    }
  }
}