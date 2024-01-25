import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/workout_db.dart';
import 'package:lightweight_app/icons.dart';
import 'package:lightweight_app/styles.dart';

class MyCurrentSplit extends StatefulWidget {
  const MyCurrentSplit({super.key});

  @override
  State<MyCurrentSplit> createState() => _MyCurrentSplitState();
}

class _MyCurrentSplitState extends State<MyCurrentSplit> with TickerProviderStateMixin{
  late final TabController _tabController;
  late WorkoutsDBHelper workoutDb;
  List<Workout> allWorkoutsList = [];
  Workout offDay = Workout(id: 'offDay', name: 'Off', exerciseIdString: '', setsString: '');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    workoutDb = WorkoutsDBHelper();
    workoutDb.openWorkouts().whenComplete(() async {
      final data = await workoutDb.getAllWorkouts();
      data.insert(0, offDay);

      setState(() {
        allWorkoutsList = data;
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
    //return planYourWorkoutsWidget(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Current Split'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              child: IconButton(
                onPressed: () {
                  editCurrentSplitDialog(_tabController.index);
                },
                icon: MyIcons().addIcon(), 
              ),
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.blue,
          tabs: const <Widget>[
            Tab(
              text: 'M',
            ),
            Tab(
              text: 'T',
            ),
            Tab(
              text: 'W',
            ),
            Tab(
              text: 'T',
            ),
            Tab(
              text: 'F',
            ),
            Tab(
              text: 'S',
            ),
            Tab(
              text: 'S',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
        tabViewBody(),
        Text('hi'),
        Text('hi'),
        Text('hi'),
        Text('hi'),
        Text('hi'),
        Text('hi'),
        ],
      )
    );
  }

  Column tabViewBody() {
    return const Column(
      children: <Widget> [
        Text('workoutname'),
         Divider(
          thickness: 2,
        ),
      ]
    );
  } 

  void editCurrentSplitDialog(int i) {
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
                    return selectWorkoutItem(index);
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
  Padding selectWorkoutItem(int i) {
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
               
              }, 
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  allWorkoutsList[i].name,
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
}