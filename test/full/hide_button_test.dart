part of ice_test;

hide_button_tests() {
  group("Hide Button", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      new Store().clear();
    });

    test("hides code", () {
      _test(_) {
        helpers.click('button', text: 'Hide Code');
        expect(
          query('.ice-code-editor-editor').style.display,
          equals('none')
        );
      }
      editor.editorReady.then(expectAsync1(_test));
    });

    test("hides itself", (){
      _test(_) {
        helpers.click('button', text: 'Hide Code');
        expect(
          helpers.queryWithContent('button', 'Hide Code').style.display,
          equals('none')
        );
      }
      editor.editorReady.then(expectAsync1(_test));
    });

    test("hides main menu button", (){
      _test(_) {
        helpers.click('button', text: 'Hide Code');
        expect(
          helpers.queryWithContent('button', '☰').style.display,
          equals('none')
        );
      }
      editor.editorReady.then(expectAsync1(_test));
    });

    test("hides update button", (){
      _test(_) {
        helpers.click('button', text: 'Hide Code');
        expect(
          helpers.queryWithContent('button', ' Update').style.display,
          equals('none')
        );
      }
      editor.editorReady.then(expectAsync1(_test));
    });

    test("shows the show button", (){
      _test(_) {
        helpers.click('button', text: 'Hide Code');
        expect(
          helpers.queryWithContent('button', 'Show Code').style.display,
          equals('')
        );
      }
      editor.editorReady.then(expectAsync1(_test));
    });

    // TODO: show button shows everything
  });
}
