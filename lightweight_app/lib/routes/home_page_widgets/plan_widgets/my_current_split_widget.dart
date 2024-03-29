import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/current_split_db.dart';
import 'package:lightweight_app/db_helper/workout_db.dart';
import 'package:lightweight_app/assets/icons.dart';
import 'package:lightweight_app/assets/styles.dart';

class MyCurrentSplit extends StatefulWidget {
  const MyCurrentSplit({
    super.key,
    required this.myCurrentSplit,
    required this.currentSplitDb,
    required this.callbackCurrentSplit,
  });

  final Function callbackCurrentSplit;
  final CurrentSplit myCurrentSplit;
  final CurrentSplitDBHelper currentSplitDb;

  @override
  State<MyCurrentSplit> createState() => _MyCurrentSplitState();
}

class _MyCurrentSplitState extends State<MyCurrentSplit> with TickerProviderStateMixin{
  late final TabController _tabController;
  late WorkoutsDBHelper workoutDb;
  late List<Workout> allWorkoutsList;

  _refreshCurrentSplit() {
    setState(() {
      widget.callbackCurrentSplit();
    });
  }
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this, initialIndex: DateTime.now().weekday - 1);
    workoutDb = WorkoutsDBHelper();
    workoutDb.openWorkouts().whenComplete(() async {
      final workouts = await workoutDb.getAllWorkouts();

      setState(() {
        allWorkoutsList = workouts;
        allWorkoutsList.insert(0, Workout.restDay());
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Current Split'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              child: IconButton(
                onPressed: () {
                  changeWorkoutDialog(_tabController.index);
                },
                icon: MyIcons().editIcon(), 
              ),
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.inversePrimary,
          unselectedLabelColor: Colors.white,
          indicatorColor: Theme.of(context).colorScheme.inversePrimary,
          labelPadding: const EdgeInsets.symmetric(horizontal: 10),
          tabs: const <Widget>[
            Tab(
              text: 'Mon',
            ),
            Tab(
              text: 'Tues',
            ),
            Tab(
              text: 'Wed',
            ),
            Tab(
              text: 'Thur',
            ),
            Tab(
              text: 'Fri',
            ),
            Tab(
              text: 'Sat',
            ),
            Tab(
              text: 'Sun',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
        tabViewBody(0),
        tabViewBody(1),
        tabViewBody(2),
        tabViewBody(3),
        tabViewBody(4),
        tabViewBody(5),
        tabViewBody(6),
        ],
      )
    );
  }

// display workout information based on dayIndex
  Column tabViewBody(int dayIndex) {
    return Column(
      children: <Widget> [
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
            top: 20,
          ),
          child: Column(
            children: <Widget>[
              Text(
                widget.myCurrentSplit.workoutList[dayIndex].name,
                style: Styles().largeDialogHeader(),
              ),
              if(widget.myCurrentSplit.workoutList[dayIndex].id != 'RestDay')
                const Divider(
                  thickness: 2,
                ),
            ],
          ),
        ),
        Expanded(
          child:
           ListView.builder(
            itemCount: widget.myCurrentSplit.workoutList[dayIndex].exerciseList.length,
            itemBuilder: (BuildContext context, int index) {
              String num = widget.myCurrentSplit.workoutList[dayIndex].setsList[index];
              String sub = '$num Reps';

              return Card(
                child: ListTile(
                  title: Text(widget.myCurrentSplit.workoutList[dayIndex].exerciseList[index].name),
                  subtitle: Text(sub),
                ),
              );
            },
          ),
        ),
      ],
    );
  } 

  // change workout based on dayIndex 
  void changeWorkoutDialog(int dayIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: 550.0,
          child: Column(
            children: <Widget>[
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:  MyIcons().backArrowIcon(),
                  ),
                  const Spacer(),
                  const Spacer(),
                  Text(
                    'Select a Workout',
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
                  itemCount: allWorkoutsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return selectAWorkoutItem(dayIndex, index);
                  }
                ),
              ),
              const Spacer(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  // adds the selected workout to the users current split. 
  Padding selectAWorkoutItem(int dayIndex, int itemIndex) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                ),
                backgroundColor: Colors.transparent,
              ),
              onPressed: () {
                setState(() {
                  widget.myCurrentSplit.workoutList[dayIndex] = allWorkoutsList[itemIndex];
                });
                onSubmitUpdate();
                _refreshCurrentSplit();
                Navigator.pop(context);
              }, 
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  allWorkoutsList[itemIndex].name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }


//        ***** UPDATING A WORKOUT IN CURRENTSPLIT *****
  String updatedIdListToString() {
    String id = '';

    for(int i = 0; i < 7; ++i) {
      String anId = widget.myCurrentSplit.workoutList[i].id;
      if(i == 6) {
        id = '$id$anId';
      } 
      else {
        id = '$id$anId;';
      }
    }

    return id;
  }

  void onSubmitUpdate() async {
    String workoutId = updatedIdListToString();

    await widget.currentSplitDb.updateCurrentSplit(workoutId);
  }

}