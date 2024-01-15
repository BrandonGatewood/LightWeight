import "package:flutter/material.dart";
import '../../../icons.dart';
import './my_workouts_dialog.dart';

class Workouts extends StatefulWidget {
  const Workouts({super.key});

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  late TextEditingController _controller;
  MyIcons icons = MyIcons();
  WorkoutsDialog workoutsDialog = WorkoutsDialog();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
                dialog(0);
              },
              icon: icons.addIcon(), 
            ),
          ),
        ],
      ),
      //body: layout(),
    );
  }

  /*
    dialog function selects the approrate dialog to display

    this function can display add, edit, or delete dialog.
  */
  void dialog(int options) {
    List<Widget> dialogList = <Widget>[];

    switch(options) {
      case 0:
        dialogList = workoutsDialog.editWorkoutDialog(context, _controller);
        break;
      case 1:
        dialogList = workoutsDialog.editWorkoutDialog(context, _controller);
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 220.0,
          width: 300.0,
          child: Column(
            children: dialogList,              
          ),
        ),
      ),
    );
  }

  
  

  
}