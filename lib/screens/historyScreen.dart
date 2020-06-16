import 'package:flutter/material.dart';
import '../widgets/singleSession.dart';
import '../constants.dart' as Constants;
import '../databases/history_helper.dart';
import '../screens/trainingSummaryScreen.dart';

class MyHistoryScreen extends StatefulWidget {
  @override
  _MyHistoryScreenState createState() => _MyHistoryScreenState();

  MyHistoryScreen();
}

class _MyHistoryScreenState extends State<MyHistoryScreen> {
  Future historyFuture;
  SingleChildScrollView historyList;

  Map<String, dynamic> selectedSession;

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
    var sessionsDataList =
        await HistoryHelper.getListOfStartTimesAndDurations();

    var usedColor = Constants.greyColor;
    int colorIndex = 0;
    sessionsDataList.forEach((s) {
      colorIndex++;
      var indexSeconds = DateTime.fromMillisecondsSinceEpoch(s['startTime'])
          .toString()
          .indexOf('.');

      sessions.add(SingleSession(
        '---.- km in ' + s['duration'].split('.')[0] + ' - xxx Calories',
        DateTime.fromMillisecondsSinceEpoch(s['startTime'])
            .toString()
            .substring(0, indexSeconds - 3),
        colorIndex % 2 == 1 ? Constants.greyColorSelected : Constants.greyColor,
        s,
        onSessionSelected,
      ));

      if (context != null) {
        sessions
            .add(SizedBox(height: MediaQuery.of(context).size.width * 0.03));
      }
    });

    historyList = SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sessions,
    ));

    return historyList;
  }

  void onSessionSelected(Map<String, dynamic> session) {
    setState(() {
      selectedSession = session;
    });
  }

  void onBackToList() {
    setState(() {
      selectedSession = null;
    });
  }

  @override
  void initState() {
    super.initState();
    historyFuture = buildHistory();
    selectedSession = null;
  }

  Widget futureBody() {
    return FutureBuilder<Widget>(
      future: historyFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return selectedSession == null
                ? historyList
                : MyTrainingScreenSummary(selectedSession, onBackToList);
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backGroundColor,
      body: futureBody(),
    );
  }
}
