// ignore_for_file: prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'sensor.dart';

class ChartComp extends StatelessWidget {
  final List<SensorValue> allData;

  const ChartComp({Key? key, required this.allData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final DateTime date =
                    DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Text('${date.minute}:${date.second}');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: allData
                .map((e) => FlSpot(
                      e.time.millisecondsSinceEpoch.toDouble(),
                      e.value,
                    ))
                .toList(),
            isCurved: true,
            barWidth: 3,
            color:Colors.red,
          ),
        ],
      ),
    );
  }
}
