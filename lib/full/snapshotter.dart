part of ice;

class Snapshotter {
  Full full;

  static get dateStr => new DateTime.now().toIso8601String().replaceFirst('T', ' ').replaceFirst(new RegExp(r':\d\d\.\d\d\d.*'), '');

  Snapshotter(this.full);

  void take() {
    var currentProjectTitle = full.store.currentProjectTitle;

    var lastSnapshot = full.store.projectsIncludingSnapshots.
        firstWhere((item) => item[Store.title].contains(new RegExp('^SNAPSHOT: $currentProjectTitle')), orElse: () => {});
    if(lastSnapshot['code'] == full.store.currentProject['code']) return;

    var title = 'SNAPSHOT: $currentProjectTitle ($dateStr)';
    full.store[title] = full.store.currentProject;
    full.store[title]['snapshot'] = true;
  }

}