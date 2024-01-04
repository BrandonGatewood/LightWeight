import "package:flutter/material.dart";
import '../app_bar/track_workout_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Open a connection to DB
    
    return Column(
      children: <Widget>[
        // Workout overview title
        const SizedBox(
          // SizedBox styling
          height: 50,
          child: Center(
            child: Text(
              'Todays Workout Overview',
              // Text Style
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25, 
              ),
            ),
          )
        ),
        // Workout Overview
        SizedBox(
          // SizedBox Styling 
          height: 500,
          child: ListView(
            children: const <Widget>[
              Card(
                child: ListTile(
                  title: Text('Incline Dumbbell Bench'),
                  subtitle: Text('\t3 x 10'),
                ),
              ),
            ],
          ),
        ),
        // Edit Workouts Button and Track Workouts Button
        Expanded(
          child: Row(
            children: <Widget>[
              const Spacer(

              ),
              ElevatedButton(
                child: const Text('Edit Workouts'),
                onPressed: () {
                  
                },
              ),
              const Spacer(
              ),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TrackWorkoutPage()));
                },
                child: const Row(
                  children: <Widget>[
                    Icon(
                      Icons.track_changes_rounded
                    ),
                    Spacer(

                    ),
                    Text("Track Workout"), // text
                  ],
                ),
              ),
              const Spacer(
              ),
            ],
          ),
        ),
      ],
    );
    
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
}
