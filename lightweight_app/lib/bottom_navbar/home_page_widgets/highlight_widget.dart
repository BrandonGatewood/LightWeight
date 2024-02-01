import "package:flutter/material.dart";
import 'package:lightweight_app/charts/body_weight_chart.dart';
import 'package:lightweight_app/charts/exercise_chart.dart';
import 'package:lightweight_app/db_helper/user_db.dart';
import 'package:lightweight_app/db_helper/workout_db.dart';

class Highlight extends StatefulWidget {
  const Highlight({
    super.key,
    required this.aUser,
    required this.aWorkout,
  });

  final User aUser;
  final Workout aWorkout;

  @override
  State<Highlight> createState() => _Highlight(); 
}

class _Highlight extends State<Highlight> {
  late int selectedPage;
  late final PageController _pageController;

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int pageCount = 4;
    return SizedBox(
      height: 790,
      child: Column(
        children: <Widget>[
          BodyWeightChart(aUser: widget.aUser,),
          ExerciseChart(aWorkout: widget.aWorkout),
        ],
      )
    );
   
  }

  /*
    Get a random favorite exercise
  */
  String getRandomFavoriteExercise() {
    List<String> myExercises = ['squats', 'pull up', 'bench'];

    // return random exercise
    return 'chest';
  }
  /* 
    Get the weight used on first rep from the picked exercise
  */
  int firstRepWeight(String myExercises) {
    // find number of reps from that exercise
    return 144;
  }
  Widget favoriteExercise(BuildContext context) {
    String name = getRandomFavoriteExercise();
    int weight = firstRepWeight(name);

    final PageController controller = PageController();
    return PageView(
      controller: controller,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            child: ListTile(
              title: Text(name),
              subtitle: Text('chart of first rep progress'),
            ),
          ),
        ),
            Card(
              child: ListTile(
                title: Text('Incline Dumbbell Bench'),
                subtitle: Text('\t3 x 10'),
              ),
            ),
      ],
    );
  }
  




}