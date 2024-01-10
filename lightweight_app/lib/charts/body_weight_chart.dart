import "package:flutter/material.dart";
import 'package:fl_chart/fl_chart.dart';

class BodyWeightChart extends StatefulWidget {
  const BodyWeightChart({super.key});

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

  Widget chartCard() {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 330,
            child: Card(
              child: Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text('Body Weight Chart'),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 15,
                        left: 10,
                        top: 20,
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
          ),
        ),
      ],
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
        text = '100 lbs';
        break;
      case 2:
        text = '200 lbs';
        break;
      case 3:
        text = '300 lbs';
        break;
      case 4:
        text = '400 lbs';
        break;
      default:
        return Container();
    }

    return Padding(
      padding: EdgeInsets.only(right: 3),
      child: Text(
        text, 
        style: style, 
        textAlign: TextAlign.left
      )
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
          spots: bodyWeightDummyData(),
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

  List<FlSpot> bodyWeightDummyData() {
    return [
      FlSpot(1, 184/100),
      FlSpot(2, 183/100),
      FlSpot(3, 185/100),
      FlSpot(4, 190/100),
      FlSpot(5, 185/100),
      FlSpot(6, 183/100),
      FlSpot(7.2, 200/100),
      FlSpot(8, 170/100),
      FlSpot(9, 170/100),
      FlSpot(10, 170/100),
    ];
  }
}