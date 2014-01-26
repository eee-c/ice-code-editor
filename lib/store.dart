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
  List _projects;

  Store({this.storage_key: codeEditor});
  //   // Uncomment this (and method below) to migrate development data
  //   // _migrateFromTitleIdToFilename();
  // }

  HashMap get currentProject {
    if (this.isEmpty)
      return {'code': ''}..[title] = 'Untitled';

    return projects.first;
  }

  String get currentProjectTitle => currentProject[title];

  int get length => projects.length;

  HashMap operator [](String key) {
    return projects.
      firstWhere(
        (p) => p[title] == key,
        orElse: () => null
      );
  }

  void operator []=(String key, HashMap data) {
    data[title] = key;

    _updateAtIndex(_indexOfKey(key), data);

    _sync();
  }

  int _indexOfKey(String key) => projects.indexOf(this[key]);

  // TODO: use Dart's built-in ordered hashmap
  void _updateAtIndex(i, data) {
    data.putIfAbsent('updated_at', ()=> new DateTime.now().toString());
    if (i == -1) {
      projects.insert(0, data);
      projects[0].putIfAbsent('created_at', ()=> new DateTime.now().toString());
    }
    else {
      var created_at = projects[i]['created_at'];
      projects[i] = data;
      projects[i]['created_at'] = created_at;
    }
  }

  bool get isEmpty => projects.isEmpty;
  bool get isNotEmpty => projects.isNotEmpty;
  Iterable<String> get keys => projects.map((p)=> p[title]);
  Iterable<HashMap> get values => projects;
  bool containsKey(key) => keys.contains(key);
  bool containsValue(value) => values.contains(value);
  void forEach(f) {
    projects.forEach((p)=> f(p[title], p));
  }
  HashMap remove(key) {
    var i = _indexOfKey(key);
    if (i == -1) return null;

    var removed = projects.removeAt(i);
    _sync();
    return removed;
  }
  void clear() {
    _projects = [];
    _sync();
    window.localStorage.remove(storage_key);
  }
  HashMap putIfAbsent(key, f) {
    var i = _indexOfKey(key);
    if (i == -1) {
      this[key] = f();
    }
    return this[key];
  }
  void addAll(recs) {
    recs.forEach((key, rec)=> this[key] = rec);
  }

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
    if (_projects != null) return _projects;

    var json = window.localStorage[storage_key];
    return _projects = (json == null) ? [] : JSON.decode(json);
  }

  /// Force the list of projects to refresh itself by reloading from
  /// localStorage.
  void refresh() => _projects = null;

  bool _frozen = false;
  /// Prevent further syncs to localStorage
  void freeze() { _frozen = true; }

  void _sync() {
    if (_frozen) return;
    window.localStorage[storage_key] = JSON.encode(projects);
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
