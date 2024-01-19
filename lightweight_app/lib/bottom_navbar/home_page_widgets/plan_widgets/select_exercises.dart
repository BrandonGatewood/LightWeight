import "package:flutter/material.dart";
import "package:lightweight_app/bottom_navbar/home_page_widgets/plan_widgets/my_exercises_widget.dart";
import '../../../db_helper/exercise_db.dart';
import '../../../db_helper/workout_db.dart';
import '../../../icons.dart';
import '../../../styles.dart';

class WorkoutSelectExercises extends StatefulWidget {
  const WorkoutSelectExercises({
    super.key,
    required this.workoutName,
  });

  final String workoutName;

  @override
  State<WorkoutSelectExercises> createState() => _WorkoutSelectExerciseState();
}

class _WorkoutSelectExerciseState extends State<WorkoutSelectExercises> {
  List<TextEditingController> _controller = [];
  late ExerciseDBHelper _dbHelper;
  late List<Exercise> exerciseList;
  List<String> selectedList = [];
  MyIcons icons = MyIcons(); 


  @override
  void initState() {
    super.initState();
    _dbHelper = ExerciseDBHelper();
    _dbHelper.openExercise().whenComplete(() async {
      final data = await _dbHelper.getAllExercise();

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
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                selectExerciseDialog();
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
    mainLayout function determines which layout to use by the size of selectedList. 
  */
  Widget mainLayout() {
    // Run get all exercises from Workout object
    // and declare as exerciseList
    if(selectedList.isEmpty){
      return const Center(child: Text('Workout is empty'),);
    }
    else {
      return selectedExercises();
    }
  }

  /*
    selectedExercises builds a ListView for all the exercises in the selectedList
  */
  ReorderableListView selectedExercises() {
      return ReorderableListView(
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
    int reps = int.parse(_controller[i].text);

    return SizedBox(
      key: Key('$i'),
      height: 115,
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    anExercise,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      // delete from selectedList
                      // append back to exerciseList
                      // reset state.
                    },
                    icon: icons.deleteIcon(),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 65,
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _controller[i],
                    decoration: Styles().inputWorkoutName('reps'),
                    textAlign: TextAlign.center, 
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ++reps;

                    setState(() {
                      _controller[i].text = reps.toString();
                    }); 
                  },
                  icon: icons.addIcon(),
                ),
                IconButton(
                  onPressed: () {
                    --reps;
                    
                    _controller[i].text = reps.toString();
                  },
                  icon: icons.minusIcon(),
                ),
                const Spacer(),
              ],
            ),
          ],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 500.0,
          width: 400.0,
          child: Column(
            children: selectionLayout(),              
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
  List<Widget> selectionLayout() {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Select Exercise',
            style: Styles().dialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
      SizedBox(
        height: 440,
        width: 350,
        child: ListView.builder(
          itemCount: exerciseList.length,
          itemBuilder: (BuildContext context, int index) {
            return exerciseSelection(index);
          }
        ),
      ) ,
    ];
  }

  /*
    exerciseSelectionButton function is a button that contains an exercise name. When a button is
    selected, it will remove that exercise from exerciseList and add it to the selectedList.
  */
  Padding exerciseSelection(int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: () {
          selectedList.add(exerciseList[i].name);
          exerciseList.removeAt(i);
          TextEditingController c = TextEditingController();
          c.text = '4';
          _controller.add(c);

          setState(() {
          });

          Navigator.pop(context);
        }, 
        child: Text(
          exerciseList[i].name,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ), 
        ),
      ),
      ),
    );
  }
}
