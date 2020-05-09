import 'package:flutter/material.dart';

import '../widgets/clipShadowPath.dart';

import '../constants.dart' as Constants;

class MyTrainingDrawer extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          ClipShadowPath(
            shadow: BoxShadow(
              color: Colors.grey,
              offset: Offset(-5, 3),
              blurRadius: 5,
            ),
            clipper: _ImageDrawer(),
            child: Container(
              color : Constants.greyColorSelected,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ]
      ),
    );
  }
}

class _ImageDrawer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 414;
    final double _yScaling = size.height / 896;
    path.lineTo(0 * _xScaling,155 * _yScaling);
    path.cubicTo(0 * _xScaling,155 * _yScaling,411 * _xScaling,155 * _yScaling,411 * _xScaling,155 * _yScaling,);
    path.cubicTo(358 * _xScaling,113.846 * _yScaling,274.5 * _xScaling,1.50003 * _yScaling,206 * _xScaling,1.5 * _yScaling,);
    path.cubicTo(136.5 * _xScaling,1.49997 * _yScaling,53.8333 * _xScaling,113.117 * _yScaling,0 * _xScaling,155 * _yScaling,);
    path.cubicTo(0 * _xScaling,155 * _yScaling,0 * _xScaling,155 * _yScaling,0 * _xScaling,155 * _yScaling,);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}