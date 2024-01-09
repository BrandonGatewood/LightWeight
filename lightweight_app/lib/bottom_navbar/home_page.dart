import "package:flutter/material.dart";
import '../app_bar/track_workout_page.dart';
import 'package:lightweight_app/edit_workouts_page.dart';
import 'home_page_widgets/summary_widget.dart';
import 'home_page_widgets/planning_widget.dart';
import 'home_page_widgets/highlight_widget.dart';
import 'home_page_widgets/workout_overview_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: ListView(
          children: <Widget>[
            Text(
              'Summary',
              style: header(), 
            ),
            const Summary(),
            Text(
              'Today\'s Workout',
              style: header(),
            ),
            const WorkoutOverview(),
            Text(
              'Plan',
              style: header(),
            ),
            const Plan(),
            Text(
              'Highlights',
              style: header(),
            ),
            const Highlight(),
          ],
        ),
      ),
    );
  }

  TextStyle header() {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }
}

  /*
    findDay function uses DateTime class to find the current day.

    The function returns a String containing the day.
  */
  /*
  String findDay() {
    const Map<int, String> weekdayName = {1: "Monday", 2: "Tuesday", 3: "Wednesday", 4: "Thursday", 5: "Friday", 6: "Saturday", 7: "Sunday"};
    return weekdayName[DateTime.now().weekday].toString();
  } 
 */ 

  /*
  ListView workoutOverview() {
    String day = findDay();
    String workout = 'hi';

    if(workout.isEmpty) {
      return ListView(
            children: const <Widget>[
              Card(
                child: ListTile(
                  title: Text('No workouts today'),
                ),
              ),
            ],
      );
    }
    else {
      return ListView(
            children: const <Widget>[
              Card(
                child: ListTile(
                  title: Text('No workouts today'),
                ),
              ),
            ],
      );
    }
  }
  */