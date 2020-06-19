import 'package:flutter/material.dart';

import '../constants.dart' as Constants;
import '../widgets/lowerNavigationBarButton.dart';

class LowerNavigationBar extends StatefulWidget {
  final PageController _currentPage;
  final BuildContext _context;
  final Function selectHandler;

  LowerNavigationBar(this._currentPage, this._context, this.selectHandler);

  @override
  _LowerNavigationBarState createState() {
    return _LowerNavigationBarState();
  }
}

class _LowerNavigationBarState extends State<LowerNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Constants.greyColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          LowerNavigationBarButton(widget._currentPage, widget._context, 'Home',
              Icons.home, 0, widget.selectHandler),
          LowerNavigationBarButton(widget._currentPage, widget._context,
              'Training', Icons.directions_bike, 1, widget.selectHandler),
          LowerNavigationBarButton(widget._currentPage, widget._context,
              'History', Icons.history, 2, widget.selectHandler),
        ],
      ),
    );
  }
}
