import '../databases/base_model.dart';

class GPSReadingTableModel extends BaseModel {

  int latitude;
  int longitude;
  int readingId;

  static String primaryKeyWhereString = 'readingId = ?';

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
