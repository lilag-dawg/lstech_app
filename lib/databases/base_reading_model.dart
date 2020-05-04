import '../databases/base_model.dart';
import '../databases/reading_model.dart';

class BaseReadingTableModel extends BaseModel {
  int value;
  int readingId;

  static String primaryKeyWhereString = ReadingTableModel.pkName + ' = ?';

  BaseReadingTableModel({
    this.value,
    this.readingId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'value': value,
      'readingId': readingId,
    };
    return map;
  }

  static BaseReadingTableModel fromMap(Map<String, dynamic> map) {
    return BaseReadingTableModel(
      value: map['value'],
      readingId: map['readingId'],
    );
  }
}
