part of ice_test;

import_tests() {
  group("Import Dialog", () {
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store
        ..clear()
        ..['Project #2'] = {'code': 'Original Project #2'};

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

    test("shouldn't clobber existing projects with the same name", (){
      var dialog = new ImportDialog(editor)
        ..import(json);

      expect(
        editor.store['Project #2']['code'],
        equals('Original Project #2')
      );
    });

    test("it still imports the project as a copy of the original project", () {
      var dialog = new ImportDialog(editor)
        ..import(json);

      expect(
        editor.store['Project #2 (1)']['code'],
        equals('imported code')
      );
    });


    test("alerts user if they import non json", () {
      var dialog = new ImportDialog(editor)
        ..import("not JSON");

      expect(
          query('#alert').text,
          matches('This does not look like a ICE project file. Unable to import.')
      );
    });
  });
}
