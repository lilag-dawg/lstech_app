import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/iconTitle.dart';

import '../widgets/lowerNavigationBar.dart';
import '../widgets/customAppBar.dart';
//import '../widgets/charts.dart';
//import '../widgets/charts2.dart';
//import '../widgets/charts5.dart';

import '../constants.dart' as Constants;
import '../databases/history_helper.dart';
import '../databases/reading_model.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
//import 'package:fcharts/fcharts.dart' as charts;
import 'package:flutter/material.dart';
import '../widgets/statisticsChart.dart';

class MyTrainingScreenSummary extends StatefulWidget {
  final PageController _currentPage;
  final Function selectHandler;
  final Map<String, dynamic> session;

  MyTrainingScreenSummary(this._currentPage, this.selectHandler, this.session);
  @override
  _MyTrainingScreenSummaryState createState() =>
      _MyTrainingScreenSummaryState();
}

class _MyTrainingScreenSummaryState extends State<MyTrainingScreenSummary> {
  Future sessionFuture;

  SingleChildScrollView summary;

  Map<String, dynamic> powerStats;
  Map<String, dynamic> cadenceStats;
  List<Reading> powerChartValues;
  List<Reading> cadenceChartValues;

  var seriesList = List<charts.Series<dynamic, dynamic>>();

  Future<Widget> getStatistics() async {
    powerStats = await HistoryHelper.getStatisticsFromReadingsType(
        widget.session['sessionId'], ReadingTableModel.powerTypeString);
    cadenceStats = await HistoryHelper.getStatisticsFromReadingsType(
        widget.session['sessionId'], ReadingTableModel.cadenceTypeString);

    powerChartValues = await HistoryHelper.getChartValues(
        widget.session['sessionId'], ReadingTableModel.powerTypeString);
    cadenceChartValues = await HistoryHelper.getChartValues(
        widget.session['sessionId'], ReadingTableModel.cadenceTypeString);
    return createSummary();
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<Reading, int>> _createSampleData(List<Reading> chartValues) {
    final data = chartValues;

    return [
      new charts.Series<Reading, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Reading sales, _) => sales.time,
        measureFn: (Reading sales, _) => sales.value,
        data: data,
      )
    ];
  }

  Widget createSummary() {
    summary = SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          MyIconTitle(Icons.chevron_left, 'Sommaire d\'entrainement',
              widgetFontWeight: FontWeight.bold,
              widgetIconSize: 35,
              widgetTextSize: 25,
              isAutoSize: false),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              SizedBox(width: 70),
              MyIconTitle(Icons.alarm, 'DURÉE',
                  widgetFontWeight: FontWeight.bold),
              SizedBox(width: 73),
              Text(
                widget.session['duration'].split('.')[0], // Data de temps
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width *
                          (1.2 / 5.5) /
                          89.766) *
                      20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              SizedBox(width: 70),
              MyIconTitle(Icons.whatshot, 'CALORIES',
                  widgetFontWeight: FontWeight.bold),
              SizedBox(width: 42),
              Text(
                '---' + ' KCals', // Data de calories
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width *
                          (1.2 / 5.5) /
                          89.766) *
                      20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              SizedBox(width: 70),
              MyIconTitle(Icons.location_on, 'DISTANCE',
                  widgetFontWeight: FontWeight.bold),
              SizedBox(width: 40),
              Text(
                '--.-' + ' m', // Data de distance
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width *
                          (1.2 / 5.5) /
                          89.766) *
                      20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _dataSummary(
              context,
              Icons.offline_bolt,
              'PUISSANCE',
              powerStats != null ? powerStats['maxValue'].toString() : '--',
              powerStats != null ? powerStats['averageValue'].toString() : '--',
              'W',
              false),
          SizedBox(height: 20),
          _dataSummary(
              context,
              Icons.offline_bolt,
              'CADENCE',
              cadenceStats != null ? cadenceStats['maxValue'].toString() : '--',
              cadenceStats != null
                  ? cadenceStats['averageValue'].toString()
                  : '--',
              'RPM',
              true),
          SizedBox(height: 20),
          _dataSummary(
              context, Icons.offline_bolt, 'VITESSE', '--', '--', 'km/h', true),
          Container(
            child: SimpleLineChart(
              _createSampleData(powerChartValues),
              animate: true,
            ),
            height: 200,
            color: Colors.white,
          ),
          Container(
            child: SimpleLineChart(
              _createSampleData(cadenceChartValues),
              animate: true,
            ),
            height: 200,
            color: Colors.white,
          ),
        ],
      ),
    );

    return summary;
  }

  @override
  void initState() {
    super.initState();
    sessionFuture = getStatistics();
  }

  Widget _body(BuildContext context) {
    return FutureBuilder<Widget>(
      future: getStatistics(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return summary;
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: LowerNavigationBar(
          widget._currentPage, context, widget.selectHandler),
      body: CustomAppBar(
        body: _body(context),
      ),
      backgroundColor: Constants.backGroundColor,
    );
  }
}

Widget _dataSummary(BuildContext context, IconData icon, String title,
    String dataMax, String dataAvg, String units, bool isUnfoldMore) {
  return Container(
    child: Row(
      children: <Widget>[
        SizedBox(width: 20),
        Container(
            width: 140,
            child: MyIconTitle(Icons.offline_bolt, title,
                widgetFontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Container(width: 2, height: 60, color: Colors.black),
        SizedBox(width: 10),
        Container(
          width: 180,
          child: Column(
            children: <Widget>[
              Text(
                'Maximale ' + ' ' + dataMax + ' ' + units,
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width *
                          (1.2 / 5.5) /
                          89.766) *
                      20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Moyenne' + '   ' + dataAvg + ' ' + units,
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width *
                          (1.2 / 5.5) /
                          89.766) *
                      20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 5),
        Icon(
          isUnfoldMore ? Icons.unfold_more : Icons.unfold_less,
          size: 40,
        )
      ],
    ),
  );
}
