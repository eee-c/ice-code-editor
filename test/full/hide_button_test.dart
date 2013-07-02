part of ice_test;

hide_button_tests() {
  group("Hide Button", (){
    var editor;

    setUp((){
      editor = new Full(enable_javascript_mode: false)
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

    test("hides code", () {
      helpers.click('button', text: 'Hide Code');
      expect(
        query('.ice-code-editor-editor').style.visibility,
        equals('hidden')
      );
    });

    test("hides itself", (){
      helpers.click('button', text: 'Hide Code');
      expect(
        helpers.queryWithContent('button', 'Hide Code').style.display,
        equals('none')
      );
    });

    test("hides main menu button", (){
      helpers.click('button', text: 'Hide Code');
      expect(
        helpers.queryWithContent('button', '☰').style.display,
        equals('none')
      );
    });

    test("hides update button", (){
      helpers.click('button', text: 'Hide Code');
      expect(
        helpers.queryWithContent('button', ' Update').style.display,
        equals('none')
      );
    });

    test("shows the show button", (){
      helpers.click('button', text: 'Hide Code');
      expect(
        helpers.queryWithContent('button', 'Show Code').style.display,
        equals('')
      );
    });

    // TODO: show button shows everything
  });
}
