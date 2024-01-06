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
    // Open a connection to DB

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: ListView(
          // Todays Workout 
          children: const <Widget>[
            Text('Summary'),
            Summary(),
            Text('Today\'s Workout Overview'),
            WorkoutOverview(),
            Text('Plan'),
            Plan(),
            Text('Highlights'),
            Highlight(),
            // Planning
           

          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditWorkoutsPage())); 
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Edit Split',
            style: TextStyle(
              color: Colors.white,
            ), ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TrackWorkoutPage()));
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.blue,
          ),
          child: const Wrap(
            children: <Widget>[
              Icon(Icons.track_changes_rounded,
                color: Colors.white,
              ),
              Text('Track Workout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ]
          ),
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}

   /* 
    return Column(
      children: <Widget>[
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
  */ 
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
