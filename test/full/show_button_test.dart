part of ice_test;

show_button_tests() {
  group("Show Button", (){
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

    test("is hidden by default", (){
      expect(
        helpers.queryWithContent('button', 'Show Code').style.display,
        equals('none')
      );
    });

    test("shows code", () {
      helpers.click('button', text: 'Hide Code');
      helpers.click('button', text: 'Show Code');
      expect(
        query('.ice-code-editor-editor').style.display,
        equals('')
      );
    });

    test("hides itself", (){
      helpers.click('button', text: 'Hide Code');
      helpers.click('button', text: 'Show Code');
      expect(
        helpers.queryWithContent('button', 'Show Code').style.display,
        equals('none')
      );
    });

    test("shows main menu button", (){
      helpers.click('button', text: 'Hide Code');
      helpers.click('button', text: 'Show Code');
      expect(
        helpers.queryWithContent('button', '☰').style.display,
        equals('')
      );
    });

    test("shows update button", (){
      helpers.click('button', text: 'Hide Code');
      helpers.click('button', text: 'Show Code');
      expect(
        helpers.queryWithContent('button', ' Update').style.display,
        equals('')
      );
    });

    test("shows the hide button", (){
      helpers.click('button', text: 'Hide Code');
      helpers.click('button', text: 'Show Code');
      expect(
        helpers.queryWithContent('button', 'Hide Code').style.display,
        equals('')
      );
    });
  });
}
