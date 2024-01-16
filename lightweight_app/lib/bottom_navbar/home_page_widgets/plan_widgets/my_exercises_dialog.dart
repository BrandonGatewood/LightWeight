import "package:flutter/material.dart";
import "package:lightweight_app/db_helper/exercise_db.dart";
import "package:lightweight_app/icons.dart";
import "my_exercises_widget.dart";
class ExerciseDialogs {
  MyIcons icons = MyIcons();

  void onSubmitAdd(BuildContext context, TextEditingController controller, ExerciseDBHelper dbHelper) async {
    if(controller.text.isNotEmpty) {
      bool add = await dbHelper.insertExercise(controller.text);

      if(add) {
        _ExercisesState()._refreshExercises();
      }
    }

    if(context.mounted){
      _ExercisesState._refreshExercises();
      controller.clear();
      Navigator.popUntil(context, (route) => route.settings.name == '/exercises');
    }
  }

  List<Widget> addExerciseDialog(BuildContext context, TextEditingController controller, ExerciseDBHelper dbHelper) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Add Exercise',
            style: dialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: controller,
          onSubmitted: (String value) {
            onSubmitAdd(context, controller, dbHelper);
          },
          decoration: inputWorkoutName('Exercise name'),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 20,
          ), 
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                onSubmitAdd(context, controller, dbHelper);
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ]; 
  }

  List<Widget> exerciseDialog(BuildContext, TextEditingController controller) {
    return <Widget>[]; 
  }
  
  
  /*
    Styles for headers, textfields ...
  */
  // Textstyle for dialog headers
  TextStyle dialogHeader() {
    return const TextStyle(
      fontSize: 20,
    );
  }

  // InputDecoration for TextField
  InputDecoration inputWorkoutName(String name) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: name
    );
  } 
}
