import 'package:flutter/material.dart';
import 'package:lstech_app/databases/test_db_helper.dart';
import '../widgets/singleSession.dart';
import '../constants.dart' as Constants;

import '../databases/base_db.dart';
import '../databases/test_session_segment_model.dart';
import '../databases/test_session_model.dart';


  var _dbTestSession = new
    BaseDB(dbFormat: TestSessionTableModel.dbFormat, dbName: TestSessionTableModel.dbName);

  var _dbTestSessionSegment = new
    BaseDB(dbFormat: TestSessionSegmentTableModel.dbFormat, dbName: TestSessionSegmentTableModel.dbName);

class MyHistoryScreen extends StatelessWidget {
  List<Widget> loadHistory(BuildContext context) {
    List<Widget> history = [
      Container(
        child: Text(
          'Historique',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
        padding: EdgeInsets.all(10),
      ),
      SingleSession(
          timeString: 'temps',
          resultString: 'résultat',
          buttonColor: Constants.greyColor),
      SizedBox(height: MediaQuery.of(context).size.width * 0.03),
      SingleSession(
          timeString: 'temps2',
          resultString: 'résultat2',
          buttonColor: Constants.greyColorSelected),
    ];

    return history;
  }

  void testDB() async {
    /*var testing = new TestDBHelper();

    await testing.initSession();
    await testing.addToSession();
    await testing.addToSession();
    await testing.addToSession();
    var testSession = await testing.queryAllSession();
    print(testSession);

    await testing.initSessionSegment();
    await testing.addToSessionSegment();
    var queriedSessionSegment = await testing.queryAllSessionSegment();
    print(queriedSessionSegment);

    //testing.deleteAllSession();
    //testing.deleteAllSessionSegment();*/
  }



  void testDB2() async {


//////////////////////////////////////////////////////////////////////////////
///
    await _dbTestSession.init();
    await _dbTestSessionSegment.init();

    await _dbTestSession.deletePermanent();
    await _dbTestSessionSegment.deletePermanent();

    await _dbTestSession.init();
    await _dbTestSessionSegment.init();
//////////////////////////////////////////////////////////////////////////////////
    TestSessionTableModel test = TestSessionTableModel();
    await _dbTestSession.insert(TestSessionTableModel.dbName, test);

    var queriedSessions = await _dbTestSession.query(TestSessionTableModel.dbName);
    print(queriedSessions);

    
    /////////////////////////////////////////////////////////////////////////////////////////
    //TestSessionSegmentTableModel testSegment = TestSessionSegmentTableModel();
    TestSessionSegmentTableModel testSegment = TestSessionSegmentTableModel(sessionId: queriedSessions[queriedSessions.length-1]['sessionId']);
    await _dbTestSessionSegment.insert(TestSessionSegmentTableModel.dbName, testSegment);

    var queriedSessionsSegment = await _dbTestSessionSegment.query(TestSessionSegmentTableModel.dbName);
    print(queriedSessionsSegment);

    //await _dbTestSessionSegment.deleteAll(TestSessionSegmentTableModel.dbName);

    ////////////////////////////////////////////////////////////////////////////////////////////////
    await _dbTestSession.deleteAll(TestSessionTableModel.dbName);
    queriedSessions = await _dbTestSession.query(TestSessionTableModel.dbName);
    print(queriedSessions);
    queriedSessionsSegment = await _dbTestSessionSegment.query(TestSessionSegmentTableModel.dbName);
    print(queriedSessionsSegment);
  }


  @override
  Widget build(BuildContext context) {
    var history = loadHistory(context);
    testDB2();

    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Wattza history',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Constants.greyColor),
        backgroundColor: Constants.backGroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: history,
        ));
  }
}
