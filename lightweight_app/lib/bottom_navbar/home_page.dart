import "package:flutter/material.dart";
import 'home_page_widgets/summary_widget.dart';
import 'home_page_widgets/plan_widget.dart';
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
            homepageSections('Summary', 0),
            homepageSections('Today\'s Workout', 1),
            homepageSections('Plan', 2),
            homepageSections('Highlights', 3),
          ],
        ),
      ),
    );
  }

  /*
    Create a generic section with appropriate title and section
  */
  Widget homepageSections(String title, int selection) {
    Widget section; 

    if(selection == 0) {
      section = const Summary();
    }
    else if(selection == 1) {
      section = const WorkoutOverview();
    }
    else if(selection == 2) {
      section = const Plan();
    }
    else {
      section = const Highlight();
    }
    
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
