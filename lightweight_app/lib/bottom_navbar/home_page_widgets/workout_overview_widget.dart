import "package:flutter/material.dart";

class WorkoutOverview extends StatelessWidget {
  const WorkoutOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return planDummyData(context);
  }

  Widget planDummyData(BuildContext context) {
    return SizedBox(
        // SizedBox Styling 
        height: 350,
        child: ListView(
          children: const <Widget>[
            Card(
              child: ListTile(
                title: Text('Incline Dumbbell Bench'),
                subtitle: Text('\t3 x 10'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Incline Dumbbell Bench'),
                subtitle: Text('\t3 x 10'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Incline Dumbbell Bench'),
                subtitle: Text('\t3 x 10'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Incline Dumbbell Bench'),
                subtitle: Text('\t3 x 10'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Incline Dumbbell Bench'),
                subtitle: Text('\t3 x 10'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Incline Dumbbell Bench'),
                subtitle: Text('\t3 x 10'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Incline Dumbbell Bench'),
                subtitle: Text('\t3 x 10'),
              ),
            ),
          ],
        ),
      );
  }
}