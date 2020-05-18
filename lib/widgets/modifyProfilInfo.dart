import 'package:flutter/material.dart';

class ModifyProfilInfo extends StatelessWidget {

  final String title;
  final String dataValue;
  final String dataUnits;
  final Function _infoItem;
  final Function _modifyItem;

  ModifyProfilInfo(this.title, this.dataValue, this.dataUnits, this._infoItem, this._modifyItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width -10,
      height: 30,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 5,
            left: 10,
            child: Text(
              title,
            ),
          ),
          Positioned(
            top: 5,
            left: 180,
            child: Text(
              dataValue + ' ' + dataUnits,
            ),
          ),
          Positioned(
            right: 65,
            child: Container(
              width: 60,
              height: 30,
              child: FlatButton(
                onPressed: (){
                  _infoItem();
                }, 
                child: Icon(
                  Icons.info_outline,
                  color: Colors.grey[700],
                )
              ),
            ),
          ),
          Positioned(
            right: 5,
            child: Container(
              width: 60,
              height: 30,
              child: FlatButton(
                onPressed: (){
                  _modifyItem();
                }, 
                child: Icon(
                  Icons.mode_edit,
                  color: Colors.grey[700],
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}