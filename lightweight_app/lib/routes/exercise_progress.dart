import 'package:flutter/material.dart';
import 'package:lightweight_app/assets/styles.dart';
import 'package:lightweight_app/db_helper/exercise_db.dart';
import 'package:path/path.dart';

class ExerciseProgress extends StatelessWidget {
  const ExerciseProgress({
    super.key,
    required this.anExercise,
  });

  final Exercise anExercise;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(anExercise.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: heading('Stats'),
              ),
            ),
            maxWeightAndReps(context),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: heading('Progress'),
              ),
            ),
            statsList(),
          ],
        ),
      ),
    );
  }

  Text heading(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Row maxWeightAndReps(BuildContext context) {
    int maxWeight = anExercise.maxWeight;
    int maxWeightReps = anExercise.maxWeightReps;
    int maxReps = anExercise.maxReps;
    int maxRepsWeight = anExercise.maxRepsWeight;

    return Row(
      children: <Widget>[
        Expanded(
          child: maxCard(context, 'Max Weight', '$maxWeight lbs for $maxWeightReps reps'),
        ),
        const Padding(
          padding: EdgeInsets.all(5),
        ),
        Expanded(
          child: maxCard(context, 'Max Reps', '$maxReps reps for $maxRepsWeight lbs'),
        ),
      ],
    );
  }

  Card maxCard(BuildContext context, String title, String content) {
    return Card( 
      elevation: 0,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Styles().cardTitle(),
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

  Expanded statsList() {
    List<String> dateList = anExercise.getDateTrackedList();

    return Expanded(
      child: ListView.builder(
        itemCount: dateList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: Styles().listViewPadding(),
            child: Card(
              child: SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        dateList[index],
                        style: Styles().cardTitle(),
                      ),
                      setsList(index),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget setsList(int dateIndex) {
    List<List<int>> allWeightsMatrix = anExercise.getAllWeightsMatrix();
    List<List<int>> allRepsMatrix = anExercise.getAllRepsMatrix();

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: SizedBox(
        height: 155,
        child: ListView.builder(
          itemCount: allWeightsMatrix[dateIndex].length,
          itemBuilder: (context, index) {
            int set = index + 1;
            int weight = allWeightsMatrix[dateIndex][index];
            int reps = allRepsMatrix[dateIndex][index];

            
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text('Set $set'),
                      const Spacer(),
                      Text('$weight lbs x $reps reps'),
                    ],
                  ),
                ),
                const Divider(
                    thickness: 2,
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}