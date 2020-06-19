import '../databases/base_model.dart';

class StandardReadingTableModel extends BaseModel {
  //Cadence, Power

  static String cadenceTableName = 'cadence_reading_table';
  static String powerTableName = 'power_reading_table';
  int value;
  int readingId;

  static String primaryKeyWhereString = 'readingId = ?';

  StandardReadingTableModel({
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

  static StandardReadingTableModel fromMap(Map<String, dynamic> map) {
    return StandardReadingTableModel(
      value: map['value'],
      readingId: map['readingId'],
    );
  }
}
