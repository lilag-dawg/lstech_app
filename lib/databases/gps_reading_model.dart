import '../databases/base_model.dart';
import '../databases/reading_model.dart';

class GPSReadingTableModel extends BaseModel {
  static String dbName = 'gps_reading_table';
  static String dbFormat = 'CREATE TABLE ' +
      dbName +
      ' (latitude INTEGER, longitude INTEGER, FOREIGN KEY(readingId) REFERENCES ' +
      ReadingTableModel.dbName +
      '(' +
      ReadingTableModel.pkName +
      ') ON DELETE CASCADE)';

  int latitude;
  int longitude;
  int readingId;

  static String primaryKeyWhereString = ReadingTableModel.pkName + ' = ?';

  GPSReadingTableModel({
    this.latitude,
    this.longitude,
    this.readingId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'latitude': latitude,
      'longitude': longitude,
      'readingId': readingId,
    };
    return map;
  }

  static GPSReadingTableModel fromMap(Map<String, dynamic> map) {
    return GPSReadingTableModel(
      latitude: map['latitude'],
      longitude: map['longitude'],
      readingId: map['readingId'],
    );
  }
}
