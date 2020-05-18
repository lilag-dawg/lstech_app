import '../databases/base_model.dart';

class WattzaTableModel extends BaseModel {
  String uniqueId;
  String localName;

  static String primaryKeyWhereString = 'uniqueId = ?';

  WattzaTableModel({
    this.uniqueId,
    this.localName,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'uniqueId': uniqueId,
      'localName': localName,
    };
    return map;
  }

  static WattzaTableModel fromMap(Map<String, dynamic> map) {
    return WattzaTableModel(
        uniqueId: map['uniqueId'], localName: map['localName']);
  }
}
