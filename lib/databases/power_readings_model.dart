import '../databases/base_readings_model.dart';

abstract class PowerReadingsTableModel extends BaseReadingsTableModel {
  static String dbName = 'power_readings_table';
  static String dbFormat = 'CREATE TABLE ' +
      dbName +
      ' (readTime TEXT PRIMARY KEY NOT NULL, readValue TEXT, FOREIGN KEY(trainingStartTime) REFERENCES training_sessions_table(trainingStartTime) ON DELETE CASCADE, FOREIGN KEY(email) REFERENCES users_table(email) ON DELETE CASCADE)';
}
