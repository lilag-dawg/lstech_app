import 'package:flutter/material.dart';
import '../constants.dart' as Constants;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text("Wattza"),
      bottom: PreferredSize(
        child: Container(
          color: Colors.orange,
          height: 100,
        ),
        preferredSize: Size.fromHeight(100.0),
      ),
      backgroundColor: Constants.greyColor,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class CustomAppBar2 extends AppBar{
  CustomAppBar2() : super(title: Text("Wattza"),backgroundColor: Constants.greyColor, bottom: PreferredSize(
        child: Container(
          color: Colors.orange,
          height: 100,
        ),
        preferredSize: Size.fromHeight(100.0),
      ));
}
