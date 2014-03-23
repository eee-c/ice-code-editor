part of ice;

class Settings { ///implements HashMap<String, Object> {
  /// The key used to identify the data in localStorage.
  String storage_key;

  /// The default key used to identify the data in localStorage.
  static const String codeEditor = 'codeeditor_settings';

  HashMap model = {};

  Settings({this.storage_key: codeEditor});

  clear() {
    model.clear();
  }

  void operator []=(String key, Object data) { model[key] = data; }
  Object operator [](String key) => model[key];

  int get length => model.length;
}