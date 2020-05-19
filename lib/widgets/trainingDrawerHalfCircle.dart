import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/iconTitle.dart';
import 'dart:math' as math;

import '../constants.dart' as Constants;

IconData playPauseIcon = Icons.play_arrow;
String playPauseString = 'Démarrer';

class MyArc extends StatefulWidget {
  final double diameter;
  final double width;
  final Function endOfTrainingClicked;

  const MyArc(this.width, this.endOfTrainingClicked, {Key key, this.diameter = 200}) : super(key: key);

  @override
  _MyArcState createState() => _MyArcState();
}

class _MyArcState extends State<MyArc> {
  double _height = 200;
  double offsetStack = 0;
  bool isRaised = true;
  bool isPlayShown = true;

  void _playPausePressed(){
    setState(() {
      if(isPlayShown){
        playPauseIcon = Icons.pause;
        playPauseString = 'Pause';
        isPlayShown = false;
      }
      else{
        playPauseIcon = Icons.play_arrow;
        playPauseString = 'Démarrer';
        isPlayShown = true;
      }
    });
  }

  void _updateState(){
    setState(() {
      if (isRaised){
        _height = 100;
        offsetStack = 50;
        isRaised = false;
      }
      else{
        _height = 200;
        offsetStack = 0;
        isRaised = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isRaised? _actionBarRaised(_height, widget.width, offsetStack, _updateState, widget.endOfTrainingClicked, _playPausePressed): _actionBarReduced(_height, widget.width, offsetStack, _updateState);
  }
}

Widget _actionBarRaised(double height, double width, double offsetStack, Function _updateState, Function endOfTrainingClicked, Function _playPausePressed) {
  return Container(
    width: width,
    height: 100,
    child: Stack(
      children: <Widget>[
        Container(
          width: width,
          height: 100,
        ),
        Positioned(
          top: offsetStack,
          child: CustomPaint(
            painter: MyPainter(height, width),
            size: Size(200, 20),
          ),
        ),
        Positioned(
          left: width / 3.3 - 30,
          top: offsetStack,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60,
                height: 30,
                child: FlatButton(
                  color: Constants.greyColorSelected,
                  child: Icon(Icons.arrow_drop_down, size: 30),
                  onPressed: (){
                    _updateState();
                  },
                ),
              ),
              MyIconTitle(Icons.timer, '1 min 0 s'),
              Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    child: FlatButton(
                      color: Constants.greyColorSelected,
                      child: Column(
                        children: <Widget>[
                          Icon(playPauseIcon),
                          SizedBox(width: 5),
                          Text(playPauseString)
                        ],
                      ),
                      onPressed: (){
                        _playPausePressed();
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  FlatButton(
                    color: Constants.greyColorSelected,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.crop_square),
                        SizedBox(width: 5),
                        Text('Terminer')
                      ],
                    ),
                    onPressed: (){
                      endOfTrainingClicked(true);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ]
    ),
  );
}

Widget _actionBarReduced(double height, double width, double offsetStack, Function _updateState) {
  return Container(
      width: width,
      height: 100,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: offsetStack,
            child: CustomPaint(
              painter: MyPainter(height, width),
              size: Size(200, 20),
            ),
          ),
          Positioned(
            top: offsetStack,
            left: width / 3.3 - 30,
            child:Column(
              children: <Widget>[
                RaisedButton(
                  child: Icon(
                    Icons.arrow_drop_up,
                    size: 30,
                  ),
                  onPressed: (){
                    _updateState();
                  },
                ),
                Text(
                  'Glisser pour terminer ou suspendre'
                )
              ],
            ),
          )
        ],
       ),
    );
}


// This is the Painter class
class MyPainter extends CustomPainter {
  final double height;
  final double width;

  MyPainter(this.height,this.width);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Constants.greyColorSelected;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(width/2, height/2),
        height: height,
        width: width,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}