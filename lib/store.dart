part of ice;

/**
 * Persistent storage for ICE projects.
 *
 * Projects are unique by title, which is used to lookup projects in the
 * store. The list of projects is guaranteed to remain ordered by last
 * modification so that the most recently worked on projects are listed
 * first. After every update, the list is sync'd with localStorage to prevent
 * work from being lost.
 */
class Store implements HashMap<String, HashMap> {
  /// The key used to identify the data in localStorage.
  String storage_key;

  /// The default key used to identify the data in localStorage.
  static const String codeEditor = 'codeeditor';

  /// The record ID attribute
  static const String title = 'filename';
  LinkedHashMap _projects;

  /// Include snapshots by default (normally they are not displayed).
  bool show_snapshots = false;

  Store({this.storage_key: codeEditor}) {
    _projects = deserialize();
  }
  //   // Uncomment this (and method below) to migrate development data
  //   // _migrateFromTitleIdToFilename();
  // }


  LinkedHashMap deserialize() {
    var json = window.localStorage[storage_key];
    var projects = (json == null) ? [] : JSON.decode(json);

    var map = new LinkedHashMap();
    projects.reversed.forEach((p){
      map[p[title]] = p;
    });
    return map;
  }

  HashMap get currentProject {
    if (this.isEmpty)
      return {'code': ''}..[title] = 'Untitled';

    return _projectsExcludingSnapshots.first;
  }

  String get currentProjectTitle => currentProject[title];

  int get length => projects.length;

  HashMap operator [](String key)=> _projects[key];

  void operator []=(String key, HashMap data) {
    data[title] = key; // store filename directly in DB record

    data.putIfAbsent('updated_at', ()=> new DateTime.now().toString());

    if (_projects.containsKey(key)) {
      data['created_at'] = _projects[key]['created_at'];
      _projects.remove(key);
    }
    else {
      data.putIfAbsent('created_at', ()=> new DateTime.now().toString());
    }
    _projects[key] = data;

    _sync();
  }

  bool get isEmpty => _projects.isEmpty;
  bool get isNotEmpty => _projects.isNotEmpty;
  Iterable<String> get keys => _projects.keys;
  Iterable<HashMap> get values => _projects.values;
  bool containsKey(key) => _projects.containsKey(key);
  bool containsValue(value) => _projects.containsValue(value);
  void forEach(f) { _projects.forEach(f); }

  HashMap remove(key) {
    var removed = _projects.remove(key);
    _sync();
    return removed;
  }
  void clear() {
    _projects = new LinkedHashMap();
    _sync();
    window.localStorage.remove(storage_key);
  }
  HashMap putIfAbsent(key, f)=> _projects.putIfAbsent(key, f);

  void addAll(recs)=> _projects.addAll(recs);

  String nextProjectNamed([original_title]) {
    if (this.isEmpty) return "Untitled";

    if (original_title == null) original_title = currentProjectTitle;
    if (!containsKey(original_title)) return original_title;

    RegExp copy_number_re = new RegExp(r"\s+\((\d+)\)$");
    var title = original_title.replaceFirst(copy_number_re, "");

    var same_base = values.where((p) {
      return p['filename'].startsWith(title);
    });

    var copy_numbers = same_base.map((p) {
        var stringCount = copy_number_re.firstMatch(p['filename']);
        return stringCount == null ? 0 : int.parse(stringCount[1]);
      })
      .toList()
      ..sort();

    var count = copy_numbers.last;

    return "$title (${count+1})";
  }

  /// The list of all projects in the store.
  List get projects {
    return show_snapshots ?
      _projectSnapshots : _projectsExcludingSnapshots;
  }

  List get snapshots {
    return _projectsIncludingSnapshots.
      where((p) => p['snapshot'] == true).
      toList();
  }

  List get _projectsExcludingSnapshots {
    return _projectsIncludingSnapshots.
      where((p)=> p['snapshot'] != true).
      toList();
  }

  List get _projectsIncludingSnapshots {
    if (_projects == null) return [];

    return _projects.
      values.
      toList().
      reversed.
      toList();
  }

  List get _projectSnapshots {
    return _projectsIncludingSnapshots.
      where((p)=> p['snapshot'] == true).
      toList();
  }


  /// Refresh projects data from localStorage.
  void refresh() {
    _projects = deserialize();
  }

  bool _frozen = false;
  /// Prevent further syncs to localStorage
  void freeze() { _frozen = true; }

  void _sync() {
    if (_frozen) return;
    if (show_snapshots) return;

    window.localStorage[storage_key] = JSON.encode(_projectsIncludingSnapshots);
    _syncController.add(true);
  }

  /// Stream that will see events whenever data is synchronized with
  /// localStorage (create, update, delete).
  Stream<bool> get onSync => _syncController.stream.asBroadcastStream();
  StreamController __syncController;
  StreamController get _syncController {
    if (__syncController != null) return  __syncController;
    return __syncController = new StreamController();
  }

  // _migrateFromTitleIdToFilename() {
  //   if (currentProject.containsKey(title)) return;
  //   _projects = projects.map((p) {
  //       p[title] = p['title'];
  //       return p;
  //     }).
  //     toList();;
  //   _sync();
  // }
}
