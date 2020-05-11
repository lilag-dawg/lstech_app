import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/iconTitle.dart';

import '../widgets/lowerNavigationBar.dart';
import '../widgets/customAppBar.dart';

import '../constants.dart' as Constants;
import '../databases/history_helper.dart';
import '../databases/reading_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../widgets/statisticsChart.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
  List<charts.Series<Reading, int>> _createChartData(
      List<Reading> chartValues) {
    final data = chartValues;

    return [
      new charts.Series<Reading, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.black,
        domainFn: (Reading sales, _) => sales.time,
        measureFn: (Reading sales, _) => sales.value,
        data: data,
      )
    ];
  }

  Widget createSummary() {
    var graphWidth = MediaQuery.of(context).size.width / 1.3;
    var graphHeight = MediaQuery.of(context).size.height / 5;
    var graphColor = Colors.grey[50];

    var test = [
      Column(children: [
        Text(
          'Puissance instantannée',
          style: TextStyle(
            fontSize:
                (MediaQuery.of(context).size.width * (1.2 / 5.5) / 89.766) * 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        Container(
          child: Text('Watts'),
          alignment: Alignment.centerLeft,
          width: graphWidth,
        ),
        Container(
          child: SimpleLineChart(
            _createChartData(powerChartValues),
            animate: true,
          ),
          height: graphHeight,
          width: graphWidth,
          color: graphColor,
        ),
        Container(
          child: Text('temps'),
          alignment: Alignment.topRight,
          width: graphWidth,
        ),
      ]),
      Column(children: [
        Text(
          'Cadence instantannée',
          style: TextStyle(
            fontSize:
                (MediaQuery.of(context).size.width * (1.2 / 5.5) / 89.766) * 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        Container(
          child: Text('RPM'),
          alignment: Alignment.centerLeft,
          width: graphWidth,
        ),
        Container(
          child: SimpleLineChart(
            _createChartData(cadenceChartValues),
            animate: true,
          ),
          height: graphHeight,
          width: graphWidth,
          color: graphColor,
        ),
        Container(
          child: Text('temps'),
          alignment: Alignment.topRight,
          width: graphWidth,
        ),
      ]),
    ];

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
          Container(
            height: graphHeight * 1.6,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return test[index];
              },
              itemCount: 2,
              pagination:
                  new SwiperPagination(), //      activeColor = this.activeColor ?? Colors.grey[400];//themeData.primaryColor;
              //color = this.color ?? Colors.grey[300];//themeData.scaffoldBackgroundColor;

              //control: new SwiperControl(),
            ),
          ),
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