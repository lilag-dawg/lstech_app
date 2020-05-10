import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/iconTitle.dart';

import '../widgets/lowerNavigationBar.dart';
import '../widgets/customAppBar.dart';

import '../constants.dart' as Constants;
import '../databases/history_helper.dart';
import '../databases/reading_model.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fcharts/fcharts.dart'; // as charts;
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  // X value -> Y value
  static const myData = [
    ["A", "✔"],
    ["B", "❓"],
    ["C", "✖"],
    ["D", "❓"],
    ["E", "✖"],
    ["F", "✖"],
    ["G", "✔"],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
        child: LineChart(
      lines: [
        new Line<List<String>, String, String>(
          data: myData,
          xFn: (datum) => datum[0],
          yFn: (datum) => datum[1],
        ),
      ],
      chartPadding: new EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 30.0),
    ));
  }
}
