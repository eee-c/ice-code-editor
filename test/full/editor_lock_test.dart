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

    // TODO: start here....
    // test('creates an existing lock', (){
    //   expect(EditorLock.existing, isTrue);
    // });
  });

  solo_group('Editor Lock, no previous sessions', (){
    test('it knows there no sessions exist', (){
      expect(EditorLock.existing, isFalse);
    });
  });
}
