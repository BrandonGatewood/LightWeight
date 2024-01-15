import "package:flutter/material.dart";
import 'package:sqflite/sqflite.dart';
import '../../../icons.dart';

enum SampleItem {editWorkout, changeName, deleteWorkout}

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

  List<Widget> workoutDialog(BuildContext context, TextEditingController controller) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Workout Name',
            style: dialogHeader(), 
          ),
          const Spacer(),
          const WorkoutsDialogPopUp(),
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

class WorkoutsDialogPopUp extends StatefulWidget {
  const WorkoutsDialogPopUp({super.key});

  @override
  State<WorkoutsDialogPopUp> createState() => _WorkoutsDialogPopUp();
}
class _WorkoutsDialogPopUp extends State<WorkoutsDialogPopUp> {

  @override
  Widget build(BuildContext context) {
    SampleItem? selectedMenu;
    WorkoutsDialog dialog = WorkoutsDialog();

    return PopupMenuButton<SampleItem>(
      initialValue: selectedMenu,
      // Callback that sets the selected popup menu item.
      onSelected: (SampleItem item) {
        setState(() {
          selectedMenu = item;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.editWorkout,
          child: Text('Edit'),
        ),
        PopupMenuDivider(),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.changeName,
          child: Text('Rename'),
        ),
        PopupMenuDivider(),
        PopupMenuItem<SampleItem>(
          value: SampleItem.deleteWorkout,
          child: const Text('Delete'),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                child: SizedBox(
                  height: 220.0,
                  width: 300.0,
                  child: Column(
                    children: dialog.deleteWorkoutDialog(this.context),              
                  ),
                ),
              ),
            );
          },
        ),
      ]
    );
  }
}