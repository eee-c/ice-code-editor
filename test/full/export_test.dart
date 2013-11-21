part of ice_test;

export_tests() {
  group("Export", () {
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store
        ..clear()
        ..['Project 01'] = {'code': 'Test 01'}
        ..['Project 02'] = {'code': 'Test 02'}
        ..['Project 03'] = {'code': 'Test 03'};

      return editor.editorReady;
    });

  	tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("it downloads the source as a file", (){
      var el = new ExportDialog(editor).el;
      expect(el.download, equals("Export"));
      expect(el.href, startsWith("blob:"));
    });

    test("closes the main menu", () {
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Export');

      expect(queryAll('li'), helpers.elementsAreEmpty);
    });

  });
}
