part of ice;

class Snapshotter {
  Full full;

  Snapshotter(this.full);

  void take() {
    var currentProjectTitle = full.store.currentProjectTitle;
    var dateStr = new DateTime.now().toIso8601String().replaceFirst('T', ' ').replaceFirst(new RegExp(r':\d\d\.\d\d\d.*'), '');
    var title = 'SNAPSHOT: $currentProjectTitle ($dateStr)';
    full.store[title] = {};
  }

}