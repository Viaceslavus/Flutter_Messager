class UserSettings {
  static final UserSettings _singleton = UserSettings._internal();

  String? userName;

  factory UserSettings() {
    return _singleton;
  }

  UserSettings._internal();
}
