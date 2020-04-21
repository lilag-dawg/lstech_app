import 'package:flutter/material.dart';
import '../databases/base_model.dart';

class UsersTableModel extends BaseModel {
  static String dbName = 'users_table';
  static String dbFormat = 'CREATE TABLE ' +
      dbName +
      ' (email TEXT PRIMARY KEY NOT NULL, forename TEXT, surname TEXT, birthday TEXT)';

  String forename;
  String surname;
  String birthday; //ISO-8601
  String email;

  UsersTableModel({@required this.forename, @required this.surname, this.birthday, this.email});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'forename': forename,
      'surname': surname,
      'birthday': birthday,
      'email' : email,
    };
    return map;
  }

  static UsersTableModel fromMap(Map<String, dynamic> map) {
    return UsersTableModel(
        forename: map['forename'], surname: map['surname'], birthday: map['birthday'], email: map['email']);
  }
}
