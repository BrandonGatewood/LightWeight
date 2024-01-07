import "package:flutter/material.dart";

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: <Widget>[
              // Todays Workout
              Expanded(
                child: getMissedWorkouts(context),
              ),
              // Weight
              Expanded(
                child: getWeight(context),
              ),
            ],
          ),
        )
      ],
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

  /*
    Function to generate a card for the summary section
  */
  Widget summaryCard(BuildContext context, String title, String content) {
    return Card( 
      elevation: 0,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: SizedBox(
        height: 80,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: 
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    title,
                    style: titleStyle(),
                  ),
                ),
            ),
            Text(
              content,
              style: contentStyle(),
            ),
          ],
        ),
      ),
    );
  }

  /*
    Reusable Function to style texts
  */
  TextStyle contentStyle() {
    return const TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
    );
  }
  TextStyle titleStyle() {
    return const TextStyle(
      fontSize: 14,
    );
  }
}