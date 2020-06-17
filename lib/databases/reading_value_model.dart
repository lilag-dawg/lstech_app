import '../databases/base_model.dart';

class ReadingValueTableModel extends BaseModel { //Cadence, Power

  static String cadenceTableName = 'cadence_reading_table';
  static String powerTableName = 'power_reading_table';
  static String gpsTableName = 'power_reading_table';
  int value;
  int readingId;

  static String primaryKeyWhereString = 'readingId = ?';

  ReadingValueTableModel({
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

  static ReadingValueTableModel fromMap(Map<String, dynamic> map) {
    return ReadingValueTableModel(
      value: map['value'],
      readingId: map['readingId'],
    );
  }
}
