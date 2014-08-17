part of ice_test;

snapshotter_tests() {
  group('Snapshotter', () {
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

    solo_test('take a snapshot of code', () {
      editor.snapshotter.take();
      var dateStr = new DateTime.now().toIso8601String().replaceFirst('T', ' ').replaceFirst(new RegExp(r':\d\d\.\d\d\d.*'), '');
      print(dateStr);
      expect(editor.store['SNAPSHOT: Saved Project ($dateStr)'], isNotNull);
    });
    //TODO: snapshot should have the snapshot flag set to true
  });
}