part of ice;

class Snapshotter {
  Full full;
  final duration = const Duration(seconds: 8);

  static get dateStr => new DateTime.
    now().
    toIso8601String().
    replaceFirst('T', ' ').
    replaceFirst(new RegExp(r':\d\d\.\d\d\d.*'), '');

  Snapshotter(this.full) {
    _startTimer();
  }

  void take() {
    var currentProjectTitle = full.store.currentProjectTitle;

    var lastSnapshot = full.store.snapshots.
      firstWhere((item) => item[Store.title].
        startsWith('SNAPSHOT: $currentProjectTitle ('),
        orElse: () => {}
      );

    if (lastSnapshot['code'] == full.store.currentProject['code']) return;

    var title = 'SNAPSHOT: $currentProjectTitle ($dateStr)';

    full.store[title] = new Map.from(full.store.currentProject)
      ..[Store.title] = title
      ..['snapshot'] = true;

    trimTo20(full.store);
  }

  static trimTo20(store) {
    var all = store.snapshots;

    if (all.length <= 20) return;

    for (var i=all.length-1; i<all.length; i++) {
      store.remove(all[i][Store.title]);
    }
  }

  void _startTimer() {
    new Timer.periodic(duration, (_){ take(); });
  }
}
