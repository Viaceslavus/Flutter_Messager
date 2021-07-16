
class UserSettings {
  static final UserSettings _singleton = UserSettings._internal();

  String? userName;

  factory UserSettings() {
    return _singleton;
  }

  UserSettings._internal();

  _abs(num value) => value + 1;

  add(){
    print(_abs(5));
  }
}


