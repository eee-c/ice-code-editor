part of ice_test;

update_button_tests() {
  group("Update Button", (){
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store
        ..clear()
        ..['Current Project'] = {'code': 'Test'};

      var preview_ready = new Completer();
      editor.onPreviewChange.listen((e){
        if (preview_ready.isCompleted) return;
        preview_ready.complete();
      });
      return preview_ready.future;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("updates the preview layer", (){
      document.activeElement.
        dispatchEvent(new TextEvent('textInput', data: '<h1>Hello</h1>'));

      editor.onPreviewChange.listen(expectAsync((_)=> true));

      helpers.click('button', text: " Update");
    });

    test("Checkbox is on by default", (){
      var button = helpers.queryWithContent("button","Update");
      var checkbox = button.query("input[type=checkbox]");
      expect(checkbox.checked, isTrue);
    });

    test("Autoupdate is set in the editor by default", (){
      expect(editor.ice.autoupdate, isTrue);
    });

    test("When you uncheck the checkbox autoupdate is disabled", (){
      var button = helpers.queryWithContent("button","Update");
      var checkbox = button.query("input[type=checkbox]");

      checkbox.click();
      expect(editor.ice.autoupdate, isFalse);
    });

    // If this test starts failing randomly, try bumping up the wait
    test("checking the checkbox updates the preview layer", (){
      var button = helpers.queryWithContent("button","Update");
      var checkbox = button.query("input[type=checkbox]");
      checkbox.click();

      document.activeElement.
        dispatchEvent(new TextEvent('textInput', data: '<h1>Hello</h1>'));

      editor.onPreviewChange.listen(expectAsync((_)=> true));

      var wait = new Duration(milliseconds: 10);
      new Timer(wait, (){
        checkbox.click();
      });
    });

    test("focuses code", (){
      helpers.click('button', text: " Update");

      expect(document.activeElement.tagName, 'TEXTAREA');
    });
  });
}
