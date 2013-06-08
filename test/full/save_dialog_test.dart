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
      editor.store['Saved Project'] = {'code': 'asdf'};

      editor.editorReady.then(
        expectAsync1((_)=> expect(editor.content, 'asdf'))
      );
    });

    test("clicking save closes the main menu", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text:  'Save');

      expect(queryAll('li'), helpers.elementsAreEmpty);
    });

    skip_test("", (){});
  });
}
