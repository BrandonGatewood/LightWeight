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
  late ExerciseDBHelper exerciseDb;
  late List<Exercise> exerciseList;
  late List<String> selectedList;
  late List<String> selectedIdList;
  MyIcons icons = MyIcons(); 

  @override
  void initState() {
    super.initState();
    exerciseDb = ExerciseDBHelper();
    exerciseDb.openExercise().whenComplete(() async {
      final exercises = await exerciseDb.getAllExercise();
      
      setState(() {
        exerciseList = exercises;
      });
    });

    final setsList = widget.workout.getExerciseSets();

    setState(() {
      selectedList = widget.workout.exerciseList;
      selectedIdList = widget.workout.getExerciseIdList();

      if(setsList.isNotEmpty) {
        for(int i = 0; i < setsList.length; ++ i) {
          TextEditingController c = TextEditingController();
          c.text = setsList[i];
          _controller.add(c);
        }
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
        title: const Text('Select Exercises'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              radius: 25,
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
    if(selectedList.isEmpty){
      return const Center(
        child: Text('Workout is empty'),
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 120,
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
          for(int i = 0; i < selectedList.length; ++i)
          selectedExerciseCard(selectedList[i], i),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              --newIndex;
            }
            final String item = selectedList.removeAt(oldIndex);
            final TextEditingController c = _controller.removeAt(oldIndex);
            selectedList.insert(newIndex, item);
            _controller.insert(newIndex, c);
          });
        },
    );
  }

  /*
    exerciseCard builds a card for each exercise. Each card will contain the selected
    exercise name, 

    , delete icon to remove the selected exercise. 
  */ 
  SizedBox selectedExerciseCard(String anExerciseName, int i) {
    int sets = int.parse(_controller[i].text);

    return SizedBox(
      key: Key('$i'),
      height: 80,
      child: Card(
        child: 
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row( 
                children: <Widget>[
                  Text(
                    anExerciseName,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 49,
                    height: 65,
                    child: TextField(
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      controller: _controller[i],
                      decoration: Styles().inputWorkoutName('sets'),
                      textAlign: TextAlign.center, 
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ++sets;

                      setState(() {
                        _controller[i].text = sets.toString();
                      }); 
                    },
                    icon: icons.addIcon(),
                  ),
                  IconButton(
                    onPressed: () {
                      --sets;
                      
                      _controller[i].text = sets.toString();
                    },
                    icon: icons.minusIcon(),
                  ),
                ],
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
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 550.0,
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
                    style: Styles().dialogHeader(), 
                  ),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
              SizedBox(
                height: 450,
                child: ListView.builder(
                  itemCount: exerciseList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return selectExerciseItem(index);
                  }
                ),
              ),
              const Spacer(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  // exerciseSelectionItem function is a button that contains an exercise from the exerciseList. 
  Padding selectExerciseItem(int i) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
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
                selectedList.add(exerciseList[i].name);
                selectedIdList.add(exerciseList[i].id);
                TextEditingController c = TextEditingController();
                c.text = '4';
                _controller.add(c);

                setState(() {
                });

                Navigator.pop(context);
              }, 
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  exerciseList[i].name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }


//        ***** PARSE SUBMIT DATABASE *****

  // Converts the selected exercises in selectList to string and return it
  String selectedListToString() {
    String id = '';

    for(int i = 0; i < selectedIdList.length; ++i) {
      String anId = selectedIdList[i];
      if(i == selectedIdList.length - 1) {
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

    for(int i = 0; i < _controller.length; ++i) {
      String set = _controller[i].text;

      if(i == _controller.length - 1) {
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
}
