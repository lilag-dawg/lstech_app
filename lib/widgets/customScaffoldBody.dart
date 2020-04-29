import 'package:flutter/material.dart';

import '../screens/findDevicesScreen.dart';
import '../constants.dart' as Constants;

class CustomScaffoldBody extends StatefulWidget {
  
  final Widget body;
  CustomScaffoldBody({this.body});
  @override
  _CustomScaffoldBodyState createState() => _CustomScaffoldBodyState();
}

class _CustomScaffoldBodyState extends State<CustomScaffoldBody> {

  ScrollController _controller;
  IconData arrowIcon;
  final double defaultAppBarHeight = 56.0; //kToolbarHeight
  double expandedHeight = 400;
  //double expandedHeight = MediaQuery.of(context).size.height/2;

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      //print("top reach");
      setState(() {
        arrowIcon = Icons.arrow_drop_down;
      });
    }
    if (_controller.offset < _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      //print("not at top");
      if (arrowIcon != Icons.arrow_drop_up) {
        setState(() {
          arrowIcon = Icons.arrow_drop_up;
        });
      }
    }
  }


  @override
  void initState() {
    _controller = ScrollController(
        initialScrollOffset: expandedHeight - defaultAppBarHeight);
    _controller.addListener(_scrollListener);
    arrowIcon = Icons.arrow_drop_down;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        controller: _controller,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: expandedHeight,
            backgroundColor: Constants.greyColor,
            floating: false,
            pinned: true,
            title: Text('Wattza', style: TextStyle(color: Colors.black),),
            leading: Icon(Icons.bluetooth_connected, color: Colors.black,),
            bottom: PreferredSize(
              child: Center(
                child: Icon(arrowIcon),
              ),
              preferredSize: Size.fromHeight(0),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  SafeArea(
                    child: Container(
                    margin: EdgeInsets.only(top: defaultAppBarHeight),
                      child: FindDevicesScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: widget.body,
          ),
        ],
      );
  }
}