part of ice_test;

whats_new_tests() {
  group("What's New Menu Item", (){
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store
        ..clear()
        ..['Current Project'] = {'code': 'Test'};

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("links to friendly release summary", (){
      helpers.click('button', text: '☰');
      expect(query('.ice-menu a').href, contains('github'));
    });

    test("it opens in a new window", (){
      helpers.click('button', text: '☰');
      expect(query('.ice-menu a').target, '_blank');
    });
  });
}
