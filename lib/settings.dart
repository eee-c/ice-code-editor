part of ice;

class Settings implements Map<String, Object> {
  /// The key used to identify the data in localStorage.
  String storage_key;

  /// The default key used to identify the data in localStorage.
  static const String codeEditor = 'codeeditor_settings';

  Map _model;

  Settings({this.storage_key: codeEditor});

  // Be Map-like
  int get length => model.length;
  List<String> get keys => model.keys;
  List<Object> get values => model.values;
  putIfAbsent(String k, Function ifAbsent) => model.putIfAbsent(k, ifAbsent);
  forEach(Function f) => model.forEach(f);
  bool get isEmpty => model.isEmpty;
  bool get isNotEmpty => model.isNotEmpty;
  addAll(Map<String, Object> all) => model.addAll(all);
  remove(String k){
    model.remove(k);
    _sync();
  }
  bool containsKey(String k) => model.containsKey(k);
  bool containsValue(Object v) => model.containsValue(v);
  void clear() {
    model.clear();
    _sync();
    window.localStorage.remove(storage_key);
  }

  Object operator [](String key) => model[key];

  void operator []=(String key, Object data) {
    model[key] = data;
    _sync();
  }

  Map get model {
    if (_model != null) return _model;

    var json = window.localStorage[storage_key];
    return _model = (json == null) ? {} : JSON.decode(json);
  }

  refresh() => _model = null;

  void _sync() {
    window.localStorage[storage_key] = JSON.encode(_model);
  }
}
