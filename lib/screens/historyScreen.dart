import 'package:flutter/material.dart';
import '../widgets/singleSession.dart';
import '../constants.dart' as Constants;
import '../databases/history_helper.dart';

class MyHistoryScreen extends StatefulWidget {
  @override
  _MyHistoryScreenState createState() => _MyHistoryScreenState();
}

class _MyHistoryScreenState extends State<MyHistoryScreen> {
  List<Widget> sessions = List<Widget>();

  Future<void> buildHistory() async {
    sessions.clear();
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

    await loadSessions();
  }

  Future<void> loadSessions() async {
    Map<String, List<dynamic>> sessionTimes =
        await HistoryHelper.getListOfStartTimesAndDurations();

    for (int i = (sessionTimes['startTimes'].length - 1); i >= 0; i--) {
      var indexSeconds = sessionTimes['startTimes'][i].indexOf('.');

      sessions.add(SingleSession(
          timeString: sessionTimes['startTimes'][i].substring(0, indexSeconds - 3),
          resultString: '---.- km in ' + sessionTimes['durations'][i].split('.')[0] + ' - xxx Calories',// - 3),
          buttonColor:
              i % 2 == 0 ? Constants.greyColor : Constants.greyColorSelected));

      sessions.add(SizedBox(height: MediaQuery.of(context).size.width * 0.03));
    }
  }

  @override
  void initState() {
    super.initState();
    buildHistory().then((_) => setState(() {
          sessions = sessions;
        }));
  }

  @override
  Widget build(BuildContext context) {
    //HistoryHelper.testDB();
    return Scaffold(
            appBar: AppBar(
                title: Text(
                  'Wattza history',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Constants.greyColor),
            backgroundColor: Constants.backGroundColor,
            body:SingleChildScrollView(child :Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sessions,
            )) );
  }
}
