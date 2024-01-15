import "package:flutter/material.dart";
import '../../../icons.dart';

class WorkoutsDialog {
  MyIcons icons = MyIcons();

  List<Widget> addWorkoutDialog(BuildContext context, TextEditingController controller) {
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
          controller: controller,
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

  List<Widget> editWorkoutDialog(BuildContext context, TextEditingController controller) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Edit Workout',
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
          onSubmitted: (String value) async {

          },
          decoration: inputWorkoutName('Rename Workout'),
        ),
      ),
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () {

            },
            icon: icons.editIcon(),
          ),
          IconButton(
            onPressed: () {
              deleteWorkoutDialog(context);
            },
            icon: icons.deleteIcon(),
          ),
        ],
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

  List<Widget> deleteWorkoutDialog(BuildContext context) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Remove workout',
            style: dialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
      const Text('Confirm to remove workout.'),
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