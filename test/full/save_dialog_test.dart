part of ice_test;

save_dialog_tests(){
  group("Save Dialog", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      new Store().clear();
    });

    test("a saved project is loaded when the editor starts", (){
      editor.content = 'asdf';

      helpers.click('button', text: '☰');
      helpers.click('li', text:  'Save');

      document.query('#ice').remove();
      editor = new Full(enable_javascript_mode: false);

      _test(_) {
        expect(editor.content, equals('asdf'));
      };
      editor.editorReady.then(expectAsync1(_test));
    });

    test("clicking save closes the main menu", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text:  'Save');

      expect(queryAll('li'), helpers.elementsAreEmpty);
    });

    skip_test("", (){});
  });
}
