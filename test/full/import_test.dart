part of ice_test;

import_tests() {
  group("Import", () {
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      return editor.editorReady;
    });

  	tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    // Delete this (only left on the off chance it might help
    // when starting the next test....
    // test("it downloads the source as a file", (){
    //   var el = new ImportDialog(editor).el;
    //   expect(el.download, equals("Import"));
    //   expect(el.href, startsWith("blob:"));
    // });

    test("closes the main menu", () {
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Import');

      expect(queryAll('li'), helpers.elementsAreEmpty);
    });
  });
}
