import '../databases/base_model.dart';

class UserTableModel extends BaseModel {
  static String dbName = 'user_table';
  static String dbFormat = 'CREATE TABLE ' +
      dbName +
      ' (userId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, birthdate TEXT, sex TEXT, height INTEGER, weight INTEGER, city TEXT)';

  int userId;
  String birthdate; //ISO-8601
  String sex;
  int height;
  int weight;
  String city;

  static String primaryKeyWhereString = 'userId = ?';

  UserTableModel(
      //TODO : Verify for PK inclusion
      {this.userId,
      this.birthdate,
      this.sex,
      this.height,
      this.weight,
      this.city});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'userId': userId,
      'birthdate': birthdate,
      'sex': sex,
      'height': height,
      'weight': weight,
      'city': city
    };
    return map;
  }

  static UserTableModel fromMap(Map<String, dynamic> map) {
    return UserTableModel(
        userId: map['userId'],
        birthdate: map['birthdate'],
        sex: map['sex'],
        height: map['height'],
        weight: map['weight'],
        city: map['city']);
  }
}
