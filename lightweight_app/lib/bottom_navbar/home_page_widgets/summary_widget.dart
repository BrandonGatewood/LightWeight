import "package:flutter/material.dart";
import "package:lightweight_app/icons.dart";
import "package:lightweight_app/styles.dart";

class Summary extends StatelessWidget {
  const Summary({
    super.key,
    required this.workoutName,
  });

  final String workoutName;

  @override
  Widget build(BuildContext context) {
    return 
       Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: <Widget>[
              // Todays Workout
              Expanded(
                child: summaryCard(context, 'Today\'s Workout', workoutName),
              ),
              const Padding(
                padding: EdgeInsets.all(5)
              ),
              // Weight
              Expanded(
                child: healthButtonCard(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Function to generate buttonCard
  ElevatedButton healthButtonCard(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.inversePrimary),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      onPressed: () {
      }, 
      child: SizedBox(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Current Weight',
                    style: Styles().content(), 
                  ),
                  const Spacer(),
                  MyIcons().forwardArrowIcon(),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  '190lbs',
                  style: Styles().content(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to generate a card for the summary section
  Card summaryCard(BuildContext context, String title, String content) {
    return Card( 
      elevation: 0,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: SizedBox(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Styles().content(),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  content,
                  style: Styles().content(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




























  /* 
    Function to find users weight and returns a summaryCard.
  */
  Widget getWeight(BuildContext context) {
    // Find Weight
    String content = '190 lbs';

    return summaryCard(context, 'Weight', content);
  }

  /*
    Function to find the number of missed entries and returns a summaryCard.
  */
  Widget getMissedWorkouts(BuildContext context) {
    // Find missed entries 
    String content = '0';

    return summaryCard(context, 'Workouts Missed', content);
  }
}