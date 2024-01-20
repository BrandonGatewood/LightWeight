import "package:flutter/material.dart";
import '../../../db_helper/exercise_db.dart';
import '../../../db_helper/workout_db.dart';
import '../../../icons.dart';
import '../../../styles.dart';

class WorkoutSelectExercises extends StatefulWidget {
  const WorkoutSelectExercises({
    super.key,
    required this.workoutName,
    required this.workoutDb
  });

  final String workoutName;
  final WorkoutsDBHelper workoutDb;

  @override
  State<WorkoutSelectExercises> createState() => _WorkoutSelectExerciseState();
}

class _WorkoutSelectExerciseState extends State<WorkoutSelectExercises> {
  final List<TextEditingController> _controller = [];
  late ExerciseDBHelper exerciseDb;
  late List<Exercise> exerciseList;
  List<String> selectedList = [];
  MyIcons icons = MyIcons(); 

  @override
  void initState() {
    super.initState();
    exerciseDb = ExerciseDBHelper();
    exerciseDb.openExercise().whenComplete(() async {
      final data = await exerciseDb.getAllExercise();

      setState(() {
        exerciseList = data;
      });
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


//    *** MAIN LAYOUT FUNCTIONS ***


  /*
    mainLayout function determines which layout to use by the size of selectedList. 
  */
  Widget mainLayout() {
    // Run get all exercises from Workout object
    // and declare as exerciseList
    if(selectedList.isEmpty){
      return const Center(child: Text('Workout is empty'),);
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
          exerciseCard(selectedList[i], i),
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
  SizedBox exerciseCard(String anExercise, int i) {
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
                    anExercise,
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


//    *** SELECTING EXERCISE & DATABASE FUNCTIONS


  /*
    selectExerciseDialog function is an AlertDialog used when a user wants to add a new 
    exercise to their workout.
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
            children: selectExerciseDialogLayout(),              
          ),
        ),
      ),
    );
  }
  
  /*
    selectionLayout function is the layout for selectExerciseDialog for selecting a new workout.

    Function contains a button to return to the exercise list for that workout, and a list of
    all available exercises.
  */
  List<Widget> selectExerciseDialogLayout() {
    return <Widget>[
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
      ) ,
      const Spacer(),
      const Spacer(),
    ];
  }

  /*
    exerciseSelectionButton function is a button that contains an exercise name. When a button is
    selected, it will remove that exercise from exerciseList and add it to the selectedList.
  */
  Padding selectExerciseItem(int i) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
            ),
            backgroundColor: Colors.transparent,
            side: BorderSide( 
              width: 0.5,
              color: Colors.transparent.withOpacity(0.6),
            )
          ),
          onPressed: () {
            selectedList.add(exerciseList[i].name);
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
    );
  }


//    *** PARSE SUBMIT DATABASE ***


  // Converts the selected exercises in selectList to string and return it
  String selectedListToString() {
    String exercises = '';

    for(int i = 0; i < selectedList.length; ++i) {
      String s = selectedList[i];
      if(i == selectedList.length - 1) {
        exercises = '$exercises$s';
      }
      else {
        exercises = '$exercises$s;';
      }
    }

    return exercises;
  }

  // Converts the sets for each selected exercise in _controllerList to a single string and return it
  String controllerListToString() {
    String sets = '';

    for(final c in _controller) {
      String set = c.text;
      sets = '$sets$set;';
    }

    return sets;
  }

  /*
    onSubmiteSave function calls both selectedListToString() and controllerListToString() and
    in
  */
  void onSubmitSave() async {
    String exercises = selectedListToString();
    String reps = controllerListToString();
    await widget.workoutDb.insertWorkout(widget.workoutName,exercises, reps);

    handleRequest();
  }

  void handleRequest() {
    Navigator.popUntil(context, (route) => route.settings.name == '/workouts');
  }
}
