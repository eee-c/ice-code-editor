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

    final json = '''[{
        "filename":"Project #1",
        "code":"imported code",
        "lineNumber":0,
        "updated_at":"2014-01-02 00:00:00.000",
        "created_at":"2013-01-01 00:00:00.000"
      },
      {
        "filename":"Project #2",
        "code":"imported code",
        "lineNumber":0,
        "updated_at":"2014-01-01 00:00:00.000",
        "created_at":"2013-01-01 00:00:00.000"
      }]''';

    test("First imported project should be at the top of project list", (){
      var dialog = new ImportDialog(editor)
        ..import(json);

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      var menu_items = queryAll('li');
      expect(menu_items[0].text, 'Project #1');
    });

    test("afterwards, first project should be opened", (){
      var dialog = new ImportDialog(editor)
        ..import(json);

      expect(
        editor.content,
        equals('imported code')
      );
    });
  });
}
