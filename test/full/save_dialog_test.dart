part of ice_test;

save_dialog_tests(){
  group("Save Dialog", (){
    var editor;

    setUp((){
      editor = new Full(enable_javascript_mode: false)
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store['Saved Project'] = {'code': 'asdf'};

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("a saved project is loaded when the editor starts", (){
      expect(editor.content, 'asdf');
    });

    test("clicking save closes the main menu", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text:  'Save');

      expect(queryAll('li'), helpers.elementsAreEmpty);
    });
  });
}
