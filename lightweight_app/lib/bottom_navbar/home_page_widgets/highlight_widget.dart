import "package:flutter/material.dart";
import 'package:fl_chart/fl_chart.dart';
class Highlight extends StatefulWidget {
  const Highlight({super.key});

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
      height: 500,
      child: Column(
        children: <Widget>[
          weightHighlight(context),
          //exerciseHighlight(),
          SizedBox(
            height: 200,
            child: favoriteExercise(context),
          ),

 



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
  

  /*
    Weight card widget
  */
  Widget weightHighlight(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 200,
            child: Card(
              child: ListTile(
                title: Text('Weight Chart'),
                subtitle: Text(''),
              ),
            ),
          ),
        ),
      ],
    );
  }

/*
  Widget weightLineChart() {
    return LineChart(
      LineChartData(

      )
    );
  } 
  */
  /*
    Create a chart for weight card widget
  */
}