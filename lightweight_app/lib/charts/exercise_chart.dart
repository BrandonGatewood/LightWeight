import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lightweight_app/db_helper/workout_db.dart';
import 'package:lightweight_app/styles.dart';

class ExerciseChart extends StatefulWidget {
  @override
  const ExerciseChart({
    super.key,
    required this.aWorkout,    
  });

  final Workout aWorkout;

  @override
  State<ExerciseChart> createState() => _ExerciseChartState();
}

class _ExerciseChartState extends State<ExerciseChart> {
  late int _selectedPage;
  late PageController _pageController;
  List<Color> gradientColors = [
    Colors.deepPurple,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    _selectedPage = 0;
    _pageController = PageController(initialPage: _selectedPage);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 350,
        child: exercisePageView(),
      ),
    );
  }

  // Horizontal Scrollview for exercise cards
  PageView exercisePageView() {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.aWorkout.exerciseList.length,
      onPageChanged: (value) {
        setState(() {
          _selectedPage = value; 
        });
      },
      itemBuilder: (context, index) {
        return exerciseCard(index);
      },

    );
  }

  SizedBox exerciseCard(int exerciseIndex) {
    String name = widget.aWorkout.exerciseList[exerciseIndex].name;
    List<int> firstSetWeightList = widget.aWorkout.exerciseList[exerciseIndex].getFirstSetWeightList();

    return SizedBox(
      height: 350,
      child: Card(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text(
                  '$name: Set 1',
                  style: Styles().content(),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 25,
                  left: 10,
                  top: 10,
                  bottom: 10,
                ),
                child: LineChart(
                  exerciseChart(firstSetWeightList),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 12,
    );
    
    Text text;
    int v = value.toInt();
    if(value % 2 == 0) {
      text = Text(
        '$v',
        style: style,
      );
    }
    else {
      text = const Text('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 12,
    );

    String text;
    int v = value.toInt() * 50;
    if(value % 2 == 0) {

      text = '$v';
    }
    else {
      text = '';
    }

    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Text(
        text, 
        style: style, 
        textAlign: TextAlign.right
      ),
    );
  }

  LineChartData exerciseChart(List<int> firstSetWeightList) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Theme.of(context).colorScheme.background, 
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Theme.of(context).colorScheme.background,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles:  const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget:const  Center(
            child: Text('lbs'),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 10,
      minY: 1,
      maxY: 8,
      lineBarsData: [
        LineChartBarData(
          spots: firstSetWeightData(firstSetWeightList),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
        ),
      ],
    );
  }




  List<FlSpot> firstSetWeightData(List<int> firstSetWeightList) {
    List<FlSpot> data = [];
    //List<int> bwData = widget.aUser.getBodyWeightList();

    for(int i = 0; i < firstSetWeightList.length; ++i) {
      FlSpot dp = FlSpot(i.toDouble() + 1, firstSetWeightList[i].toDouble()/100);
      data.add(dp);
    }

    return data;
  }
}