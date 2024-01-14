import "package:flutter/material.dart";
import '../../../icons.dart';

class Workouts extends StatefulWidget {
  const Workouts({super.key});

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  late TextEditingController _controller;
  MyIcons icons = MyIcons();

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
        dialogList = addWorkoutDialog();
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

  List<Widget> addWorkoutDialog() {
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
            style: dialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: _controller,
          onSubmitted: (String value) async {

          },
          decoration: inputWorkoutName('Workout name'),
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
                
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ];
  }
  
  List<Widget> renameWorkoutNameDialog() {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Rename Workout',
            style: dialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: _controller,
          onSubmitted: (String value) async {

          },
          decoration: inputWorkoutName('New name'),
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
                
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ];
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