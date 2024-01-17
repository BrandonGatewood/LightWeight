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
      body: mainLayout(),
    );
  }


//    *** MAIN LAYOUT FUNCTIONS ***


  Widget mainLayout() {
    if
  }






  /*
    dialog function selects the approrate dialog to display

    this function can display add, edit, or delete dialog.
  */
  void dialog(int options) {
    List<Widget> dialogList = <Widget>[];

    switch(options) {
      case 0:
        dialogList = workoutsDialog.workoutDialog(context, _controller);
        break;
      case 1:
        dialogList = workoutsDialog.workoutDialog(context, _controller);
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
/*
  Widget mainLayout() {
    if(workoutList.isEmpty) {
      return const Center(
        child: Text(
          'No Exercises.',
        )
      );
    }
    else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          childAspectRatio: 1.2,
          crossAxisSpacing: 8.0, // Spacing between columns
          mainAxisSpacing: 8.0, // Spacing between rows
        ),
        itemCount: workoutList.length,
        itemBuilder: (BuildContext context, int index) {
          return exerciseCard(workoutList[index]);
        },
      );
    }
  }
 */ 

  
}