part of ice_test;

editor_lock_tests() {
  group('Editor Lock', () {
    var settings, it;

    setUp((){
      settings = new Settings()
        ..storage_key = "ice-test-settings-${currentTestCase.id}"
        ..clear();
      it = new EditorLock(settings);
    });

    tearDown(() {
      settings..clear();
    });

    test('it creates a lock in settings', (){
      expect(settings['lock'], isNotNull);
    });

    test('it can remove a lock (e.g. when browser closes)', (){
      it.remove();
      expect(settings['lock'], isNull);
    });

    test('it updates the lock regularly', (){
      var old = settings['lock'];
      new Timer(
        new Duration(milliseconds: 1),
        expectAsync((){
          it.update();
          expect(settings['lock'], greaterThan(old));
        })
      );
    });

    test('can detect an existing lock', (){
      var newSettings = new Settings()
        ..storage_key = settings.storage_key;

      var newLock = new EditorLock(newSettings);
      expect(newLock.existing, isTrue);
    });
  });

  group('Editor Lock, stale previous session', (){
    var settings, it;

    setUp((){
      settings = new Settings()
        ..storage_key = "ice-test-settings-${currentTestCase.id}"
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

  group('Editor Lock, recently active previous session', (){
    var settings, it;

    setUp((){
      settings = new Settings()
        ..storage_key = "ice-test-settings-${currentTestCase.id}"
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

  group('Editor Lock, no previous sessions', (){
    tearDown(() {
      // Even though we set the settings storage key above, the default setting
      // storage key is used by the editor lock when Full is first
      // instantiated. So we clear it here:
      Settings.clearAll();
    });
    test('it knows that no sessions exist', (){
      var settings = new Settings()
        ..storage_key = "ice-test-settings-${currentTestCase.id}"
        ..clear();
      var it = new EditorLock(settings);
      expect(it.existing, isFalse);
    });
  });
}
