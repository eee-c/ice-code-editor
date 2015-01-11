part of ice_test;

editor_lock_tests() {
  solo_group('Editor Lock', () {
    var settings, it;

    setUp((){
      settings = new Settings()..clear();
      it = new EditorLock(settings);
    });

    tearDown(() {
      settings..clear();
    });

    test('it creates a lock in settings', (){
      expect(settings['lock'], isNotNull);
    });

    test('it updates the lock regularly', (){
      var old = settings['lock'];
      new Timer(
        new Duration(milliseconds: 1),
        expectAsync((){
          it.updateLock();
          expect(settings['lock'], greaterThan(old));
        })
      );
    });

    test('can detect an existing lock', (){
      var newSettings = new Settings();
      var newLock = new EditorLock(newSettings);
      expect(newLock.existing, isTrue);
    });
  });

  solo_group('Editor Lock, stale previous session', (){
    var settings, it;

    setUp((){
      settings = new Settings()
        ..clear()
        ..['lock'] = new DateTime.now().
                       subtract(new Duration(seconds: 11)).
                       millisecondsSinceEpoch;

      it = new EditorLock(settings);
    });

    tearDown(() {
      settings..clear();
    });

    test('does NOT detect an existing lock (b/c it is stale)', (){
      expect(it.existing, isFalse);
    });
  });

  solo_group('Editor Lock, recently active previous session', (){
    var settings, it;

    setUp((){
      settings = new Settings()
        ..clear()
        ..['lock'] = new DateTime.now().
                       subtract(new Duration(seconds: 9)).
                       millisecondsSinceEpoch;

      it = new EditorLock(settings);
    });

    tearDown(() {
      settings..clear();
    });

    test('detects an existing lock (b/c it has not gone stale)', (){
      expect(it.existing, isTrue);
    });
  });

  solo_group('Editor Lock, no previous sessions', (){
    test('it knows that no sessions exist', (){
      var settings = new Settings()..clear();
      var it = new EditorLock(settings);
      expect(it.existing, isFalse);
    });
  });
}
