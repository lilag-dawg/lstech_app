import 'package:flutter/material.dart';
import '../constants.dart' as Constants;

class LowerNavigationBarButton extends StatefulWidget {
  final String _text;
  final IconData _icon;
  final int _pageNumber;
  final PageController _currentPage;
  final BuildContext _context;
  final Function selectHandler;

  LowerNavigationBarButton(this._currentPage, this._context, this._text,
      this._icon, this._pageNumber, this.selectHandler);

  @override
  _LowerNavigationBarButtonState createState() {
    return _LowerNavigationBarButtonState();
  }
}

class _LowerNavigationBarButtonState extends State<LowerNavigationBarButton> {
  var selectedPage;

  @override
  Widget build(BuildContext context) {
    selectedPage = widget._currentPage.page != null
        ? widget._currentPage.page.toInt()
        : Constants.defaultPageIndex;
    return SizedBox(
      width: MediaQuery.of(context).size.width/3,
      height: MediaQuery.of(context).size.height>500? MediaQuery.of(context).size.height/14:MediaQuery.of(context).size.height/10,
      child: FlatButton(
        highlightColor: Constants.greyColorSelected,
        color: selectedPage == widget._pageNumber ? Constants.greyColorSelected : Constants.greyColor,
        child: Column(
          children: [
            Icon(
              widget._icon,
              color:Colors.black,
            ),
            Text(widget._text,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                )),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
        onPressed: () {
          widget.selectHandler(widget._pageNumber);
          if (widget._context != null) {
            Navigator.pop(widget._context);
          }
        },
      ),
    );
  }
}
