part of ice_test;

snapshotter_tests() {
  solo_group('Snapshotter', () {
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store..clear()..['Saved Project'] = {'code': 'asdf'};

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test('take a snapshot of code', () {
      editor.snapshotter.take();
      expect(editor.store['SNAPSHOT: Saved Project (${Snapshotter.dateStr})'], isNotNull);
    });

    test('Snapshot flag set to true', () {
      editor.snapshotter.take();
      var snapshot = editor.store['SNAPSHOT: Saved Project (${Snapshotter.dateStr})'];
      expect(snapshot['snapshot'], isTrue);
    });

    test('snapshot should have copy of most recent code', () {
      editor.snapshotter.take();
      var snapshot = editor.store['SNAPSHOT: Saved Project (${Snapshotter.dateStr})'];
      expect(snapshot['code'], equals('asdf'));
    });

    test('snapshot should not be taken if code is not changed', () {
      editor.store['SNAPSHOT: Saved Project (2014-08-23 23:08)'] = {'code': 'asdf', 'snapshot': true};
      editor.snapshotter.take();
      var snapshot = editor.store['SNAPSHOT: Saved Project (${Snapshotter.dateStr})'];
      expect(snapshot, isNull);
    });

    test('snapshot deletes the oldest if if 20 snapshots exist', (){
      for (var i=0; i<20; i++) {
        editor.store['SNAPSHOT: Saved Project #$i (2014-08-30: 22:48)'] = {
          'code': 'asdf',
          'snapshot': true
        };
      }

      editor.snapshotter.take();

      var snapshot = editor.store['SNAPSHOT: Saved Project #0 (2014-08-30: 22:48)'];
      expect(snapshot, isNull);
    });

    test('snapshotting an old snapshot that is now active, strips SNAPSHOT from title', (){
      editor.store['SNAPSHOT: Saved Project (2014-09-06 23:33)'] = {
        'code': 'old snapshot',
        'snapshot': false
      };

      expect(editor.store.currentProject['code'], 'old snapshot');

      editor.snapshotter.take();
      var snapshot = editor.store['SNAPSHOT: Saved Project (${Snapshotter.dateStr})'];
      expect(snapshot['snapshot'], isTrue);
    });

    // QUESTION: should we add a test for the update-by-reference bug we ran into last time?
    // QUESTION: When someone opens a Snapshot, what happens to the flag?
    //TODO: after ?s, the last project should be opened, *not* the most recent snapshot
  });
}
