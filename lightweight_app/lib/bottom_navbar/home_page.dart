import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/current_split_db.dart';
import 'package:lightweight_app/db_helper/user_db.dart';
import 'home_page_widgets/summary_widget.dart';
import 'home_page_widgets/plan_widget.dart';
import 'home_page_widgets/highlight_widget.dart';
import 'home_page_widgets/workout_overview_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.myCurrentSplit,
    required this.currentSplitDb,
    required this.callbackCurrentSplit,
    required this.aUser,
    required this.userDb,
    required this.callbackUser,
  });

  final CurrentSplit myCurrentSplit;
  final CurrentSplitDBHelper currentSplitDb;
  final Function callbackCurrentSplit;
  final User aUser;
  final UserDBHelper userDb;
  final Function callbackUser;

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.currentSplitDb.openCurrentSplit().whenComplete(() async {
      final CurrentSplit data = await widget.currentSplitDb.getCurrentSplit();

      setState(() {
        widget.myCurrentSplit.setCurrentSplit(data);
      });
    });
    
    widget.userDb.openUser().whenComplete(() async {
      final User data = await widget.userDb.getUser();

      setState(() {
        widget.aUser.setUser(data);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: <Widget>[
          summarySection(),
          todaysWorkoutOverviewSection(),
          planSection(),
          highlightsSections(),
        ],
      ),
    );
  }

  Widget summarySection() {
    String name = widget.myCurrentSplit.getTodaysWorkout().name;

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
          Summary(workoutName: name, aUser: widget.aUser, userDb: widget.userDb, callbackUser: widget.callbackUser),
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
            child: WorkoutOverview(todaysWorkout: widget.myCurrentSplit.getTodaysWorkout()),
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
          Plan(myCurrentSplit: widget.myCurrentSplit, currentSplitDb: widget.currentSplitDb, callbackCurrentSplit: widget.callbackCurrentSplit),
        ],
      ),
    );
  }

  /*
    Create a generic section with appropriate title and section
  */
  Widget highlightsSections() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Highlights',
              style: header(), 
            ),
          ),
          Highlight(aUser: widget.aUser,),
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
}

