import "package:flutter/material.dart";
import '../../../icons.dart';
import '../../../db_helper/exercise_db.dart';
import '../../../styles.dart';

// Enum for exercise card pop up menu
enum Menu {rename, deleteExercise}

class Exercises extends StatefulWidget {
  const Exercises({super.key});

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  late TextEditingController _controller;
  late ExerciseDBHelper _dbHelper;
  MyIcons icons = MyIcons();
  List<Exercise> exerciseList = [];

  void _refreshExercises() async {
    final data = await _dbHelper.getAllExercise();

    setState(() {
      exerciseList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _dbHelper = ExerciseDBHelper();
    _dbHelper.openExercise().whenComplete(() async {
      _refreshExercises();
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyIcons icons = MyIcons();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Exercises'),
        actions: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                dialog(0, '');
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
    mainLayout function returns the appropriate Widget depending on the users exercise list.

    If the users exercise list is empty, then it will return a Text widget stating that there
    are no exercies. Otherwise it will return a ListView of the users exercises. 

    Each exercise is represented as a card, where the user can view the exercise. 
  */
  Widget mainLayout() {
    if(exerciseList.isEmpty) {
      return const Center(
        child: Text(
          'No Exercises',
        )
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: exerciseList.length,
          itemBuilder: (BuildContext context, int index) {
            return exerciseCard(exerciseList[index]);
          },
        ),
      );
    }
  }

  /*
    exerciseCard function displays each exercise in a card with a ListTile
    to display information on the exercise.

    Each card displays the exercise name as the title, max weight as the subtitle.
    and a trailing IconButton to give user more options with the exercise.
  */ 
  Card exerciseCard(Exercise anExercise) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              anExercise.name,
              style: Styles().cardTitle(),
            ),
            subtitle: const Text('Max Weight: 140lbs'),
            trailing: IconButton(
              onPressed: () {
                dialog(1, anExercise.name);
              },
              icon: icons.forwardArrowIcon(),
            ),
          ),
        ],
      ),
    ); 
  }


//    *** DIALOG FUNCTIONS ***


  /*
    dialog function selects the appropriate dialog to display. Each selection returns a
    List<Widget> to display as children for the Column widget in ShowDialog().
  */
  void dialog(int options, String name) {
    List<Widget> dialogList = <Widget>[];

    switch(options) {
      case 0: 
        dialogList = addExerciseDialog();
        break;
      case 1:
        dialogList = exerciseDialog(name);
        break; 
      case 2:
        dialogList = updateExerciseDialog(name);
        break; 
      case 3:
        dialogList = deleteExerciseDialog(name);
        break;
      case 4:
        dialogList = successDialog(name);
        break;
      case 5:
        dialogList = failedDialog(name);
        break;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 250.0,
          width: 300.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: dialogList,              
          ),
        ),
      ),
    );

    // Success or failed dialog, so return to my_exercises
    if(options == 4 || options == 5) {
      Future.delayed(
        const Duration(seconds: 2),
        () {
          Navigator.popUntil(context, (route) => route.settings.name == '/exercises'); 
        },
      );
    }
  }

  /*
    addExerciseDialog function is the layout dialog for adding a new exercise into the database.
    It includes two buttons to exit and save, and a Textfield to enter an exercise name.
  */ 
  List<Widget> addExerciseDialog() {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => pop(),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Add Exercise',
            style: Styles().dialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          maxLength: 23,
          controller: _controller,
          onSubmitted: (String value) async {
            onSubmitAdd();
          },
          decoration: Styles().inputWorkoutName('Exercise name'),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 10,
          ), 
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                onSubmitAdd();
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ]; 
  }

  /*
    exerciseDialog function is the layout dialog for an exercise. It includes a button to exit,
    and a popup menu that allows users to edit the exercise name and delete the exercise. This
    function also gets the exercises stats from the database to display.
  */
  List<Widget> exerciseDialog(String name) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          popUpMenu(name),
        ],
      ),
      Padding(padding: EdgeInsets.symmetric(horizontal: 50),
      child: Text(
            name,
            style: Styles().dialogHeader(), 
          ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Text('Max Weight: 140lbs x 8reps'),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text('Max Reps: 12reps x 100lbs'),
      ),
    ]; 
  }

  /*
    updateExerciseDialog function is the layout dialog for updating an exercise in the database.
    It includes two buttons to exit and save, and a Textfield to update an exercise name.
  */ 
  List<Widget> updateExerciseDialog(String name) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => pop(),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Rename Exercise',
            style: Styles().dialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          maxLength: 23,
          controller: _controller,
          onSubmitted: (String value) async {
            onSubmitUpdate(name);
          },
          decoration: Styles().inputWorkoutName('New exercise name'),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 10,
          ), 
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                onSubmitUpdate(name);
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ]; 
  }
  
  /*
    DeleteExerciseDialog function is the layout dialog for deleting an exercise in the database.
    It includes two buttons to exit and save, and a Text Widget stating to confirm deletion of 
    the exercise.
  */ 
  List<Widget> deleteExerciseDialog(String name) {
    return <Widget>[
      Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  icons.backArrowIcon(),
          ),
          const Spacer(),
          Text(
            'Delete Exercise',
            style: Styles().dialogHeader(), 
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
      const Spacer(),
      const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Confirm to delete Exercise',
          style: TextStyle(
            fontSize: 16,
          ),
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
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: IconButton(
              onPressed: () {
                onSubmitDelete(name);
              },
              icon: icons.checkIcon(), 
            ),
          ),
        ),
      ),
    ]; 
  }
  
  /*
    successDialog function is the layout dialog for a successful request with the database.

    The String passed in dialog, is used to determine what kind of successful request occurred.

    The successful response will display in the center of the dialog.
  */
  List<Widget> successDialog(String selection) {
    String title = '';

    switch(selection) {
      case '0':
        title = 'Exercise added to List.';
        break;
      case '1':
        title = 'Exercise updated.';
        break;
      case '2':
        title = 'Exercise deleted.';
        break;
    }

    return <Widget>[
      const Spacer(),
      Center(
        child: Text(
          title,
          style: Styles().dialogHeader(),
        ),
      ),
      const Spacer(),
    ];
  }

  /*
    failedDialog function is the layout dialog for a failed request with the database.

    The String passed in dialog, is used to determine what kind of failed request occurred.

    The failed response will display in the center of the dialog.
  */
  List<Widget> failedDialog(String selection) {
    String title = '';
    String content = 'Exercise already exists.';

    switch(selection) {
      case '0': 
        title = 'Failed to add exercise.';
        break;
      case '1':
        title = 'Failed to update exercise.';
        break;
      case '2':
        title = 'Failed to delete exercise.';
        content = 'Exercise not found.';
        break;
    }
    return <Widget>[
      const Spacer(),
      Center(
        child: Text(
          title,
          style: Styles().dialogHeader(),
        ),
      ),
      Center(
        child: Text(
          content,
        ),
      ),
      const Spacer(),
    ];
  }


//  *** POP UP MENUS ***


  /*
    popUpMenu function builds a menu for an exercise card. Pop up menu
    has only two options, edit the exercise or delete it.  
  */
  PopupMenuButton<Menu> popUpMenu(String name) {
    Menu? selectedMenu;

    return PopupMenuButton<Menu>(
      initialValue: selectedMenu,

      onSelected: (Menu item) {
        setState(() {
          selectedMenu = item;
        });
      },

      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        PopupMenuItem<Menu>(
          value: Menu.rename,
          child: const Text('Rename'),
          onTap: () {
            dialog(2, name);
          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem<Menu>(
          value: Menu.deleteExercise,
          child: const Text('Delete'),
          onTap: () {
            dialog(3, name);
          },
        ),
      ],
    );
  }

//    *** ONSUBMIT FUNCTIONS AND DATABASE REQUESTS ***


  /*
    onSubmitAdd function handles the users input with the TextEditingContoller class to
    get the users input and passes that as a parameter to add a new exercise into the 
    database.
  */
  void onSubmitAdd() async {
    bool add = await _dbHelper.insertExercise(_controller.text);

    handleRequest(add, 0);
  }

  /*
    onSubmitUpdate function handles the users input with the TextEditingContoller class to
    get the users input and passes that as a parameter to update an exercise in the 
    database.
  */
  void onSubmitUpdate(String name) async {
    bool update = await _dbHelper.updateExercise(name, _controller.text);

    handleRequest(update, 1);
  }
  
  /*
    onSubmitDelete function handles the users input to delete an exercise from the database.
  */
  void onSubmitDelete(String name) async {
    bool delete = await _dbHelper.deleteExercise(name);

    handleRequest(delete, 2);
  }

  /*
    handleRequest function is a helper function for all onSubmit functions. It will clear
    the TextEditingController and display the appropriate dialog. Whether a request was
    successful or not. 

    When a request is successful, it will refresh the layout to keep up to date with the
    list.
  */
  void handleRequest(bool flag, int selection) {
    _controller.clear();

    if(flag) {
      dialog(4, selection.toString());
      _refreshExercises();
    }
    else {
      dialog(5, selection.toString());
    }
  }

  void pop() {
    Navigator.pop(context);
    _controller.clear();
  }
}