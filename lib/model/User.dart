import '../dao/UserDao.dart';

class User {

  String username;
  String password;
  List<String> emails;

  User(String username, String password, String email) {
    this.username = username;
    this.password = password;
    this.emails = new List<String>();
    this.emails.add(email);
  }

  boolean save() async {
    UserDao.createOrUpdate(this);
  }

  static load(String username, String password, List<Email> emails) {

  }


  void addEmail(String email) {

  }
}