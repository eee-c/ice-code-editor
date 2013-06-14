part of ice_test;

show_button_tests() {
  group("Show Button", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      new Store().clear();
    });

    test("is hidden by default", (){
      _test(_) {
        expect(
          helpers.queryWithContent('button', 'Show Code').style.display,
          equals('none')
        );
      }
      editor.editorReady.then(expectAsync1(_test));
    });

    test("shows code", () {
      _test(_) {
        helpers.click('button', text: 'Hide Code');
        helpers.click('button', text: 'Show Code');
        expect(
          query('.ice-code-editor-editor').style.display,
          equals('')
        );
      }
      editor.editorReady.then(expectAsync1(_test));
    });

    test("hides itself", (){
      _test(_) {
        helpers.click('button', text: 'Hide Code');
        helpers.click('button', text: 'Show Code');
        expect(
          helpers.queryWithContent('button', 'Show Code').style.display,
          equals('none')
        );
      }
      editor.editorReady.then(expectAsync1(_test));
    });

    test("shows main menu button", (){
      _test(_) {
        helpers.click('button', text: 'Hide Code');
        helpers.click('button', text: 'Show Code');
        expect(
          helpers.queryWithContent('button', '☰').style.display,
          equals('')
        );
      }
      editor.editorReady.then(expectAsync1(_test));
    });

    test("shows update button", (){
      _test(_) {
        helpers.click('button', text: 'Hide Code');
        helpers.click('button', text: 'Show Code');
        expect(
          helpers.queryWithContent('button', ' Update').style.display,
          equals('')
        );
      }
      editor.editorReady.then(expectAsync1(_test));
    });

    test("shows the hide button", (){
      _test(_) {
        helpers.click('button', text: 'Hide Code');
        helpers.click('button', text: 'Show Code');
        expect(
          helpers.queryWithContent('button', 'Hide Code').style.display,
          equals('')
        );
      }
      editor.editorReady.then(expectAsync1(_test));
    });
  });
}
