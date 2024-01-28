import "package:flutter/material.dart";
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
    required this. currentSplitDb,
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
            //homepageSections('Summary', 0),
            todaysWorkoutOverviewSection(),
            planSection(),
            //homepageSections('Today\'s Workout', 1),
            //homepageSections('Plan', 2),
            homepageSections('Highlights', 3),
          ],
        ),
      ),
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

