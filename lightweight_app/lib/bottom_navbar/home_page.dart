import "package:flutter/material.dart";
import 'package:lightweight_app/bottom_navbar/home_page_widgets/track.dart';
import 'package:lightweight_app/db_helper/current_split_db.dart';
import 'package:lightweight_app/db_helper/workout_db.dart';
import 'home_page_widgets/summary_widget.dart';
import 'home_page_widgets/plan_widget.dart';
import 'home_page_widgets/highlight_widget.dart';
import 'home_page_widgets/workout_overview_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.myCurrentSplit,   
    required this.currentSplitDb,
    required this.callback,
  });

  final CurrentSplit myCurrentSplit;
  final CurrentSplitDBHelper currentSplitDb;
  final Function callback;

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: <Widget>[
            summarySection(),
            todaysWorkoutOverviewSection(),
            planSection(),
            homepageSections('Highlights', 3),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onPressed: () {
          Workout todaysWorkout = getTodaysWorkout();

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Track(todaysWorkout: todaysWorkout),
          ));
        },
        label: const Text('Track',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white, 
          ) 
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget summarySection() {
    Workout workout = getTodaysWorkout();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Summary',
              style: header(), 
            ),
          ),
          Summary(workoutName: workout.name),
        ],
      ),
    );

  }

  Widget todaysWorkoutOverviewSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Workout Overview',
              style: header(), 
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: WorkoutOverview(todaysWorkout: getTodaysWorkout()),
          ),
        ],
      ),
    );
  }

  Widget planSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Plan',
              style: header(), 
            ),
          ),
          Plan(myCurrentSplit: widget.myCurrentSplit, currentSplitDb: widget.currentSplitDb, callback: widget.callback,),
        ],
      ),
    );
  }

  /*
    Create a generic section with appropriate title and section
  */
  Widget homepageSections(String title, int selection) {
    Widget section; 

      section = const Highlight();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: header(), 
            ),
          ),
          section,
        ],
      )
    );
  }

  /*
    Style for each header Section
  */
  TextStyle header() {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  Workout getTodaysWorkout() {
    int todayIndex = DateTime.now().weekday - 1;
    return widget.myCurrentSplit.workoutList[todayIndex];
  }
}

