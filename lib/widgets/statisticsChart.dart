/// Example of a simple line chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleLineChart(this.seriesList, {this.animate});

  /*/// Creates a [LineChart] with sample data and no transition.
  factory SimpleLineChart.withSampleData() {
    return new SimpleLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }*/


  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList, animate: animate);
  }

  /*/// Create one series with sample hard coded data.
  static List<charts.Series<Reading, int>> _createSampleData() {
    final data = [
      new Reading(0, 5),
      new Reading(1, 25),
      new Reading(2, 100),
      new Reading(3, 75),
    ];

    return [
      new charts.Series<Reading, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Reading sales, _) => sales.time,
        measureFn: (Reading sales, _) => sales.value,
        data: data,
      )
    ];
  }*/
}

/// Sample linear data type.
class Reading {
  final int time; // minutes
  final int value;

  Reading(this.time, this.value);
}