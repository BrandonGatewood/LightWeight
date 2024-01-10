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
                      child: Text('Weight Chart'),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 18,
                        left: 12,
                        top: 24,
                        bottom: 12,
                      ),
                      child: LineChart(
                        weightData(),
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
      case 1:
        text = const Text('Jan', style: style);
        break;
      case 3:
        text = const Text('Mar', style: style);
        break;
      case 5:
        text = const Text('May', style: style);
        break;
      case 7:
        text = const Text('Jul', style: style);
        break;
      case 9:
        text = const Text('SEP', style: style);
        break;
      case 11:
        text = const Text('Nov', style: style);
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
        text = '50';
        break;
      case 2:
        text = '100';
        break;
      case 3:
        text = '150';
        break;
      case 4:
        text = '200';
        break;
      case 5:
        text = '250';
        break;
      case 6:
        text = '300';
        break;
      case 7:
        text = '350';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData weightData() {
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
      //maxX: 12,
      minY: 0,
      //maxY: 7,
      lineBarsData: [
        LineChartBarData(
          spots: const [ 
            FlSpot(1, 184),
            FlSpot(2, 183),
            FlSpot(3, 185),
            FlSpot(4, 190),
            FlSpot(5, 185),
            FlSpot(6, 183),
            FlSpot(7, 170),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          
        ),
      ],
    );
  }

  List<FlSpot> bodyWeightDummyData() {
    return [
      FlSpot(184, 1),
      FlSpot(183, 2),
      FlSpot(185, 3),
      FlSpot(190, 4),
      FlSpot(185, 5),
      FlSpot(183, 6.5),
      FlSpot(170, 7),
    ];
  }
}