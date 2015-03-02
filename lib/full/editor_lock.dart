part of ice;

class EditorLock {
  Settings settings;
  bool existing = false;
  var timer;

  final updatePeriod = const Duration(seconds: 10);

  EditorLock(this.settings) {
//    print('check activelock');
//    print(settings['lock']);
    if (_activeLockPresent) existing = true;

    if (!existing) {
      create();
      startTimer();
    }
  }

  void create() {
    this.settings['lock'] = new DateTime.now().millisecondsSinceEpoch;
  }

  void update() {
    this.settings['lock'] = new DateTime.now().millisecondsSinceEpoch;
  }

  void remove() {
    print('remove: $existing');
    if(existing == false) this.settings.remove('lock');
    if (timer != null) timer.cancel();
  }

  void startTimer() {
    timer = new Timer.periodic(
      updatePeriod,
      (_)=> this.update()
    );
  }

  bool get _activeLockPresent => _lockPresent && !_lockStale;

  bool get _lockPresent {
    var ret = this.settings['lock'] != null;
//    print(ret);

//    print(this.settings.model);
    return ret;
  }

  bool get _lockStale {
    var lockDate = new DateTime.fromMillisecondsSinceEpoch(this.settings['lock']);
    var now = new DateTime.now();
    var diff = now.difference(lockDate);

    return (diff > updatePeriod);
  }
}
