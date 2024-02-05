import "package:flutter/material.dart";
import '../../../db_helper/exercise_db.dart';
import '../../../db_helper/workout_db.dart';
import '../../../icons.dart';
import '../../../styles.dart';

class WorkoutSelectExercises extends StatefulWidget {
  const WorkoutSelectExercises({
    super.key,
    required this.workout,
    required this.workoutDb
  });

  final Workout workout;
  final WorkoutsDBHelper workoutDb;

  @override
  State<WorkoutSelectExercises> createState() => _WorkoutSelectExerciseState();
}

class _WorkoutSelectExerciseState extends State<WorkoutSelectExercises> {
  final List<TextEditingController> _controller = [];
  final TextEditingController _textController = TextEditingController();
  late ExerciseDBHelper exerciseDb;
  late List<Exercise> allExerciseList;
  late List<bool?> isCheckedList;
  MyIcons icons = MyIcons(); 

  _refreshWorkout() {
    setState(() {
      widget.workout;
    });
  }

  @override
  void initState() {
    super.initState();
    //_textController = TextEditingController();
    isCheckedList = [];
    exerciseDb = ExerciseDBHelper();
    exerciseDb.openExercise().whenComplete(() async {
      final exercises = await exerciseDb.getAllExercise();
      
      setState(() {
        allExerciseList = exercises;
        isCheckedList = List<bool>.filled(allExerciseList.length, false, growable: true);
      });
    });

    setState(() {
      for(int i = 0; i < widget.workout.setsList.length; ++i) {
        TextEditingController c = TextEditingController();

        c.text = widget.workout.setsList[i];
        _controller.add(c);
      }
    });
  }

  @override
  void dispose() {
    for(int i = 0; i < _controller.length; ++i) {
      _controller[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              child: IconButton(
                onPressed: () {
                  selectExerciseDialog();
                },
                icon: icons.addIcon(), 
              ),
            ),
          ),
        ],
      ),
      body: mainLayout(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onPressed: () {
          onSubmitSave();
        },
        label: const Text('Save',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white, 
          ) 
        ),
      ),
    );
  }


//        ***** MAIN LAYOUT FUNCTIONS *****

  // determine which layout to use by the size of selectedList. 
  Widget mainLayout() {
    if(widget.workout.exerciseList.isEmpty){
      return const Center(
        child: Text('Workout is empty'),
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.only(
          top: 5,
          //bottom: 80,
        ),
        child: selectedExercises(),
      );
    }
  }

  /*
    selectedExercises builds a ListView for all the exercises in the selectedList
  */
  ReorderableListView selectedExercises() {
      return ReorderableListView(
        buildDefaultDragHandles: true,
        children: <Widget>[
          for(int i = 0; i < widget.workout.exerciseList.length; ++i)
          selectedExerciseCard(i),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              --newIndex;
            }
            final Exercise item = widget.workout.exerciseList.removeAt(oldIndex);
            final TextEditingController c = _controller.removeAt(oldIndex);
            final String s = widget.workout.setsList.removeAt(oldIndex);

            widget.workout.exerciseList.insert(newIndex, item);
            _controller.insert(newIndex, c);
            widget.workout.setsList.insert(newIndex, s);
            _refreshWorkout();
          });
        },
    );
  }

  /*
    exerciseCard builds a card for each exercise. Each card will contain the selected
    exercise name, 

    , delete icon to remove the selected exercise. 
  */ 
  Padding selectedExerciseCard(int i) {
    EdgeInsets p;

    if(i == widget.workout.exerciseList.length - 1) {
      p = const EdgeInsets.only(bottom: 90,);
    }
    else {
      p = const EdgeInsets.all(0);
    }

    return Padding(
      key: Key('$i'),
      padding: p,
      child: SizedBox(
      height: 80,
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: Key('$i'), 
        background: Styles().deleteButtonCardBackground(), 
        confirmDismiss: (direction) async {
          bool dismis = confirmRemoveExercise(i);
          return dismis;
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row( 
              children: <Widget>[
                Text(
                  widget.workout.exerciseList[i].name,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 52,
                  height: 50,
                  child: TextField(
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    controller: _controller[i],
                    decoration: Styles().inputSets(),
                    textAlign: TextAlign.center, 
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(5),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      int sets = int.parse(_controller[i].text) + 1; 

                      _controller[i].text = sets.toString();  
                      widget.workout.setsList[i] = sets.toString();
                    }); 
                  },
                  child: icons.incrementIcon(),
                ),
                const Padding(
                  padding: EdgeInsets.all(5),
                ),
                GestureDetector(
                  onTap: () {
                   setState(() {
                      int sets = int.parse(_controller[i].text) - 1; 
                      _controller[i].text = sets.toString();  
                      widget.workout.setsList[i] = sets.toString();
                   }); 
                  },
                  child: icons.decrementIcon(),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }


//        ***** SELECTING EXERCISE & DATABASE FUNCTIONS *****

  /*
    selectExerciseDialog function is an AlertDialog used when a user wants to add a new 
    exercise to their workout. This is the layout for selecting a new Exercise to the 
    users Workout.
  */  
  void selectExerciseDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SingleChildScrollView(
          child: SizedBox(
            height: 575.0,
            child: Column(
              children: <Widget>[
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:  icons.backArrowIcon(),
                    ),
                    const Spacer(),
                    const Spacer(),
                    Text(
                      'Select Exercise',
                      style: Styles().largeDialogHeader(), 
                    ),
                    const Spacer(),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // add new exercise 
                        addExerciseDialog();
                      },
                      child: Styles().addTextButton(), 
                    ),
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
                  child: availableExercises(),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ), 
                    child: TextButton(
                      onPressed: () {
                        onSubmitSaveCheckButton();
                      },
                      child: Styles().saveTextButton(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // returns a widget depending on the exercises available in the db
  Widget availableExercises() {
    if(allExerciseList.isEmpty) {
      return const Center(
        child: Text('No exercises available'),
      );
    }
    else {
      return ListView.builder(
        itemCount: allExerciseList.length,
        itemBuilder: (BuildContext context, int index) {
          return selectExerciseItem(index);
        }
      );
    }
  }

  // exerciseSelectionItem function is a button that contains an exercise from the exerciseList. 
  StatefulBuilder selectExerciseItem(int i) {
    isCheckedList[i] = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 20, 
            right: 20,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        widget.workout.exerciseList.add(allExerciseList[i]);
                        TextEditingController c = TextEditingController();
                        c.text = '4';
                        _controller.add(c);
                        widget.workout.setsList.add(c.text);
                        _refreshWorkout();
                        Navigator.pop(context);
                      }, 
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          allExerciseList[i].name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Checkbox(
                    checkColor: Colors.white,
                    value: isCheckedList[i], 
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedList[i] = value;
                      });
                    },
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
            ],
          ),
        );
      },
    );  
  }
    


//        ***** PARSE SUBMIT DATABASE *****

  // Converts the selected exercises in selectList to string and return it
  String selectedListToString() {
    String id = '';

    for(int i = 0; i < widget.workout.exerciseList.length; ++i) {
      String anId = widget.workout.exerciseList[i].id;
      if(i == widget.workout.exerciseList.length - 1) {
        id = '$id$anId';
      }
      else {
        id = '$id$anId;';
      }
    }

    return id;
  }

  // Converts the sets for each selected exercise in _controllerList to a single string and return it
  String controllerListToString() {
    String sets = '';

    for(int i = 0; i < widget.workout.setsList.length; ++i) {
      String set = widget.workout.setsList[i];

      if(i == widget.workout.setsList.length - 1) {
        sets = '$sets$set';
      }
      else {
        sets = '$sets$set;';
      }
    }

    return sets;
  }

  // Save the exerciseList and exerciseSetsList for a workout to the database
  void onSubmitSave() async {
    String exercises = selectedListToString();
    String sets = controllerListToString();
    await widget.workoutDb.updateWorkoutExerciseList(widget.workout, exercises, sets);

    handleRequest();
  }

  // handles request when users save the exercise.
  void handleRequest() {
    Navigator.pop(context);
  }

  // Save the exercises picked using CheckBox
  onSubmitSaveCheckButton() {
    for(int i = 0; i < isCheckedList.length; ++i) {
      if(isCheckedList[i] == true) {
        widget.workout.exerciseList.add(allExerciseList[i]);
        TextEditingController c = TextEditingController();
        c.text = '4';
        _controller.add(c);
        widget.workout.setsList.add(c.text);

      }
    }
    _refreshWorkout();
    Navigator.pop(context);
  }

  // Remove the exercise from the exerciseList and exerciseSetsList for a workout
  bool confirmRemoveExercise(int i) {
    String exerciseName = widget.workout.exerciseList[i].name;
    bool dismis = false;

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
                    'Remove Exercise',
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
                  'Confirm to remove $exerciseName.',
                  style: Styles().content(),
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
                        dismis = true;
                        widget.workout.exerciseList.removeAt(i);
                        widget.workout.setsList.removeAt(i);
                        _controller.removeAt(i);
                        _refreshWorkout();
                        Navigator.pop(context);
                      },
                      icon: icons.checkIcon(), 
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return dismis;
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
                  maxLength: 28,
                  controller: _textController,
                  onSubmitted: (String value) async {
                    if(_textController.text.isNotEmpty) {
                      onSubmitAdd();
                    }
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
                      if(_textController.text.isNotEmpty) {
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
    
    _textController.clear();
  }

  // Communicates with database to add a new exercise
  void onSubmitAdd() async {
    if(validateExerciseName(_textController.text)) {
      Exercise newExercise = await exerciseDb.insertExerciseInSelectExercise(_textController.text);
      handleAddRequest(newExercise);
    }
    else {
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
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    'Exercise already exists',
                    style: Styles().largeDialogHeader(),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'Failed to add exercise',
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
  } 
  
  // Handles the state after attempting to add a new exercise
  void handleAddRequest(Exercise newExercise) {
      widget.workout.exerciseList.add(newExercise);
      TextEditingController c = TextEditingController();
      c.text = '4';
      _controller.add(c);
      widget.workout.setsList.add(c.text);
      _refreshWorkout();
      Navigator.popUntil(context, (route) => route.settings.name == '/select_exercises'); 
  }

  // Check whether or not a workout name already exists..
  bool validateExerciseName(String exerciseName) {
    for(final exercise in allExerciseList) {
      if(exercise.name == exerciseName) {
        return false;
      }
    }

    return true;
  } 
}
