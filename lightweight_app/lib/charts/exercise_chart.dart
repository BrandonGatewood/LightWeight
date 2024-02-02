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
        height: 370,
        child: exercisePageView(),
      ),
    );
  }

  SizedBox _indicator(bool isActive) {
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive
            ? 10:8.0,
        width: isActive
            ? 12:8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
              color: Theme.of(context).colorScheme.inversePrimary,
            )
            : const BoxShadow(
              color: Colors.transparent,
            ),
          ],
          shape: BoxShape.circle,
          color: isActive ? Theme.of(context).colorScheme.inversePrimary : const Color(0XFFEAEAEA),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];

    for (int i = 0; i < widget.aWorkout.exerciseList.length; i++) {
      list.add(i == _selectedPage ? _indicator(true) : _indicator(false));
    }

    return list;
  }

  // Horizontal Scrollview for exercise cards
  Stack exercisePageView() {
    return Stack(
      children: <Widget>[
        PageView.builder(
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
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 350,
            left: 20,
            right:20,
            bottom: 10
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator()
              ),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox exerciseCard(int exerciseIndex) {
    String name = widget.aWorkout.exerciseList[exerciseIndex].name;
    List<int> firstSetWeightList = widget.aWorkout.exerciseList[exerciseIndex].getFirstSetWeightList();
    int maxWeight = widget.aWorkout.exerciseList[exerciseIndex].maxWeight;
    maxWeight = (((maxWeight + 50)  ~/ 100) * 100);

    return SizedBox(
      height: 350,
      child: Card(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 20,
                  left: 15,
                  right: 15,
                ),
                child: Text(
                  '$name: Set 1',
                  style: Styles().content(),
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 25,
                  left: 10,
                  bottom: 25,
                ),
                child: LineChart(
                  exerciseChart(firstSetWeightList, maxWeight),
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
    if(value % 5 == 0) {
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
    int v = value.toInt() * 100;
    if(v % 2 == 0) {
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

  LineChartData exerciseChart(List<int> firstSetWeightList, int maxWeight) {
    double maxY;

    if(maxWeight == 50) {
      maxY = 2;
    }
    else {
      maxY = maxWeight / 100;
    }

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
          axisNameWidget: Center(
            child: Text(
              'Past 20 Tracked Workouts',
              style: Styles().subtitle(),
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: Center(
            child: Text(
              'lbs',
              style: Styles().subtitle(),
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 20,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: firstSetWeightData(firstSetWeightList),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
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
    int counter = 1;
    for(int i = firstSetWeightList.length - 1; i >= 0 ; --i) {
      if(counter < 20) {
        FlSpot dp = FlSpot(i.toDouble() + 1, firstSetWeightList[i].toDouble()/100);
        ++counter;
        data.insert(0,dp);
      }
    }

    return data;
  }
}