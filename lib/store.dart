library ice_store;

import 'dart:html';
import 'dart:collection';
import 'dart:crypto';
import 'dart:json' as JSON;
import 'package:js/js.dart' as js;

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
  const String codeEditor = 'codeeditor';
  List _projects;

  Store() { }

  static String encode(String string) {
    var gzip = js.context.RawDeflate.deflate(string);
    return CryptoUtils.bytesToBase64(gzip.codeUnits);
  }
  static String decode(String string) {
    var bytes = CryptoUtils.base64StringToBytes(string);
    var gzip = new String.fromCharCodes(bytes);
    return js.context.RawDeflate.inflate(gzip);
  }

  int get length => projects.length;

  void operator []=(String key, Object data) {
    data['title'] = key;

    _updateAtIndex(_indexOfKey(key), data);

    _sync();
  }

  int _indexOfKey(String key) => projects.indexOf(this[key]);

  void _updateAtIndex(i, data) {
    if (i == -1) {
      projects.insert(0, data);
    }
    else {
      projects[i] = data;
    }
  }

  HashMap operator [](String key) {
    return projects.
      firstWhere(
        (p) => p['title'] == key,
        orElse: () => null
      );
  }

  /// The list of all projects in the store.
  List get projects {
    if (_projects != null) return _projects;

    var json = window.localStorage[codeEditor];
    return _projects = (json == null) ? [] : JSON.parse(json);
  }

  /// Force the list of projects to refresh itself by reloading from
  /// localStorage.
  void refresh() => _projects = null;

  void _sync() {
    window.localStorage[codeEditor] = JSON.stringify(projects);
  }
}
