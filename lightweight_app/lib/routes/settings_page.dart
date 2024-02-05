import "package:flutter/material.dart";
import "package:lightweight_app/db_helper/exercise_db.dart";
import "package:lightweight_app/db_helper/user_db.dart";
import "package:lightweight_app/db_helper/workout_db.dart";
import 'package:lightweight_app/assets/icons.dart';
import 'package:lightweight_app/assets/styles.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: buttonLayout(context),
    );
  }

  Column buttonLayout(BuildContext context) {
    return Column(
      children: <Widget>[
        deleteAll(context, 0, 'Delete All Exercises Data'),
        deleteAll(context, 1, 'Delete All Workouts Data'),
        deleteAll(context, 2, 'Delete All Body Weight Data'),
        deleteAll(context, 3, 'Delete All Data'),
      ],
    );
  }

  Padding deleteAll(BuildContext context, int selection, String name) {
    if(selection == 3) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 60),
        child: ElevatedButton(
          style: deleteButtonStyle(context),
          onPressed: () {
            confirmDelete(context, selection, name, 'Confirm to delete all data');
          }, 
          child: deleteButtonSizedBox(name),
        ),
      );
    }
    else {
      String content = 'Confirm to delete all';

      if(selection == 0) {
        content = '$content exercises data';
      }
      else if(selection == 1) {
        content = '$content workouts data';
      }
      else if(selection == 2) {
        content = '$content body weight data';
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ElevatedButton(
          style: Styles().listViewButtonStyle(),
          onPressed: () {
            confirmDelete(context, selection, name, content);
          }, 
          child: deleteButtonSizedBox(name),
        ),
      );
    }
  }

  ButtonStyle deleteButtonStyle(BuildContext context) {
      return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.inversePrimary),
      );
    }

  SizedBox deleteButtonSizedBox(String name) {
    return SizedBox(
      height: 50,
      child: Row(
        children: <Widget>[
          Text(
            name,
            style: Styles().content(), 
          ),
          const Spacer(),
          MyIcons().forwardArrowIcon(),
        ],
      ),
    );
  }


  void confirmDelete(BuildContext context, int selection, String title, String content) {
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
                    icon:  MyIcons().backArrowIcon(),
                  ),
                  const Spacer(),
                  const Spacer(),
                  Text(
                    title,
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  content,
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
                        if(selection == 0) {
                          deleteAllExercises();
                        }
                        else if(selection == 1) {
                          deleteAllWorkouts();
                        }
                        else if(selection == 2) {
                          deleteAllBodyWeight();
                        }
                        else if(selection == 3) {
                          deleteAllData();
                        }
                        Navigator.pop(context);
                      },
                      icon: MyIcons().checkIcon(), 
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteAllExercises() async {
    ExerciseDBHelper exerciseDb = ExerciseDBHelper();
    exerciseDb.openExercise();

    await exerciseDb.deleteAllExercises();
  }
  
  void deleteAllWorkouts() async {
    WorkoutsDBHelper workoutsDb = WorkoutsDBHelper();
    workoutsDb.openWorkouts();

    await workoutsDb.deleteAllWorkouts();
  }

  void deleteAllBodyWeight() async {
    UserDBHelper userDb = UserDBHelper();
    userDb.openUser();

    await userDb.deleteUser();
  }

  void deleteAllData() {
    deleteAllExercises();
    deleteAllWorkouts();
    deleteAllBodyWeight();
  }
}
