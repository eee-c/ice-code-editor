part of ice_test;

keyboard_shortcuts_tests() {
  group("Keyboard Shortcuts", (){
    var editor;

    setUp((){
      editor = new Full()
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

    test("can open the new dialog", (){
      document.activeElement.dispatchEvent(
        new KeyboardEvent(
          'keydown',
          keyIdentifier: "n",
          ctrlKey: true
        )
      );

      expect(
        queryAll('button'),
        helpers.elementsContain('Save')
      );
    });

    test("can open the open dialog", (){
      document.activeElement.dispatchEvent(
        new KeyboardEvent(
          'keydown',
          keyIdentifier: "o",
          ctrlKey: true
        )
      );

      expect(
        queryAll('div'),
        helpers.elementsContain('Saved Projects')
      );
    });

    test("can toggle the code editor", (){
      document.activeElement.dispatchEvent(
        new KeyboardEvent(
          'keydown',
          keyIdentifier: "e",
          ctrlKey: true
        )
      );

      expect(
        query('.ice-code-editor-editor').style.visibility,
        equals('hidden')
      );
    });

  });
}
