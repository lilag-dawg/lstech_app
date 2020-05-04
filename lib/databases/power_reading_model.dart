import '../databases/base_reading_model.dart';
import '../databases/reading_model.dart';

abstract class PowerReadingTableModel extends BaseReadingTableModel {
  static String dbName = 'power_reading_table';
  static String dbFormat = 'CREATE TABLE ' +
      dbName +
      ' (value INTEGER, FOREIGN KEY(readingId) REFERENCES ' +
      ReadingTableModel.dbName +
      '(' +
      ReadingTableModel.pkName +
      ') ON DELETE CASCADE)';
}
