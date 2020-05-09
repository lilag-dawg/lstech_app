import 'package:flutter/material.dart';
import '../widgets/singleSession.dart';
import '../constants.dart' as Constants;
import '../databases/history_helper.dart';

class MyHistoryScreen extends StatefulWidget {
  @override
  _MyHistoryScreenState createState() => _MyHistoryScreenState();
}

class _MyHistoryScreenState extends State<MyHistoryScreen> {
  Future historyFuture;
  SingleChildScrollView historyList;

  Future<Widget> buildHistory() async {
    //await HistoryHelper.testDB();
    List<Widget> sessions = List<Widget>();
    sessions.add(Container(
      child: Text(
        'Historique',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        textAlign: TextAlign.left,
      ),
      padding: EdgeInsets.all(10),
    ));
    return await loadSessions(sessions);
  }

  Future<Widget> loadSessions(List<Widget> sessions) async {
    Map<String, List<dynamic>> sessionTimes =
        await HistoryHelper.getListOfStartTimesAndDurations();

    for (int i = (sessionTimes['startTimes'].length - 1); i >= 0; i--) {
      var indexSeconds = sessionTimes['startTimes'][i].indexOf('.');

      sessions.add(SingleSession(
          timeString:
              sessionTimes['startTimes'][i].substring(0, indexSeconds - 3),
          resultString: '---.- km in ' +
              sessionTimes['durations'][i].split('.')[0] +
              ' - xxx Calories', // - 3),
          buttonColor:
              i % 2 == 0 ? Constants.greyColor : Constants.greyColorSelected));

      if (context != null) {
        sessions
            .add(SizedBox(height: MediaQuery.of(context).size.width * 0.03));
      }
    }

    historyList = SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sessions,
    ));

    return historyList;
  }

  @override
  void initState() {
    super.initState();
    historyFuture = buildHistory();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Wattza history',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Constants.greyColor),
      backgroundColor: Constants.backGroundColor,
      body: FutureBuilder<Widget>(
        future: historyFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return historyList;
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
