part of ice;

class EditorLock {
  Settings settings;
  bool existing = false;

  final updatePeriod = const Duration(seconds: 10);

  EditorLock(this.settings) {
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
    this.settings.remove('lock');
  }

  void startTimer() {
    new Timer.periodic(
      updatePeriod,
      (_)=> this.update()
    );
  }

  bool get _activeLockPresent => _lockPresent && !_lockStale;

  bool get _lockPresent => this.settings['lock'] != null;

  bool get _lockStale {
    var lockDate = new DateTime.fromMillisecondsSinceEpoch(this.settings['lock']);
    var now = new DateTime.now();
    var diff = now.difference(lockDate);

    return (diff > updatePeriod);
  }
}
