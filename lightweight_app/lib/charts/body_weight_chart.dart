import "package:flutter/material.dart";
import 'package:fl_chart/fl_chart.dart';
import 'package:lightweight_app/db_helper/user_db.dart';
import 'package:lightweight_app/styles.dart';

class BodyWeightChart extends StatefulWidget {
  const BodyWeightChart({
    super.key,
    required this.aUser,
  });

  final User aUser;

  @override
  State<BodyWeightChart> createState() => _BodyWeightChart(); 
}

class _BodyWeightChart extends State<BodyWeightChart> {
  List<Color> gradientColors = [
    Colors.deepPurple,
    Colors.cyan,
  ];
  @override
  Widget build(BuildContext context) {
    return chartCard();
  }

  SizedBox chartCard() {
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
                  'Body Weight Chart',
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
                  bodyWeightChart(),
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

    Widget text;

    switch (value.toInt()) {
      case 2:
        text = const Text('Feb', style: style);
        break;
      case 4:
        text = const Text('Apr', style: style);
        break;
      case 6:
        text = const Text('Jun', style: style);
        break;
      case 8:
        text = const Text('Aug', style: style);
        break;
      case 10:
        text = const Text('Oct', style: style);
        break;
      case 12:
        text = const Text('Dec', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
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

    switch (value.toInt()) {
      case 1:
        text = '100';
        break;
      case 2:
        text = '200';
        break;
      case 3:
        text = '300';
        break;
      case 4:
        text = '400';
        break;
      default:
        return Container();
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

  LineChartData bodyWeightChart() {
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
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 4,
      lineBarsData: [
        LineChartBarData(
          spots: bodyWeightData(),
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

  List<FlSpot> bodyWeightData() {
    List<FlSpot> data = [];
    List<int> bwData = widget.aUser.getBodyWeightList();

    for(int i = 0; i < bwData.length; ++i) {
      FlSpot dp = FlSpot(i.toDouble() + 1, bwData[i].toDouble()/100);
      data.add(dp);
    }

    return data;
  }
}