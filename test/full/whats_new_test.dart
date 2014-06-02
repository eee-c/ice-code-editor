part of ice_test;

whats_new_tests() {
  group("What's New Menu Item", (){
    var editor;

    setUp((){
      editor = new Full()
        ..settings.storage_key = "ice-test-settings-${currentTestCase.id}"
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store
        ..clear()
        ..['Current Project'] = {'code': 'Test'};

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
      editor.settings..clear();
    });

    test("links to friendly release summary", (){
      var action = new WhatsNewAction(editor);
      expect(action.el.href, contains('github'));
    });

    test("it opens in a new window", (){
      var action = new WhatsNewAction(editor);
      expect(action.el.target, '_blank');
    });

    group("existing editor, what's new hasn't been clicked", (){
      test("what's new menu item should be highlighted", (){
        helpers.click('button', text: '☰');
        expect(query('.ice-menu li.highlighted').text, "What's New");
      });
    });

    group("existing editor, what's new has been clicked", () {
      setUp(() {
        editor.settings..clear();
        editor.rememberWhatsNewClicked();
      });

      test("what's new menu item should not be highlighted", () {
        helpers.click('button', text: '☰');
        expect(query('.ice-menu li.highlighted'), isNull);
      });

      test("the star should be removed when what's new is clicked", () {
        expect(query('#somethingsnew'), isNull);
      });
    });
  });

  group("what's new clicked in a previous session", (){
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}"
        ..settings.storage_key = "ice-test-settings-${currentTestCase.id}"
        ..settings['clicked_whats_new'] = true;

      editor.store
        ..clear()
        ..['Untitled'] = {'code': 'Test'};

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("what's new menu item should not be highlighted", () {
      helpers.click('button', text: '☰');
      expect(query('.ice-menu li.highlighted'), isNull);
    });

    test("the star should not be present", () {
      expect(query('#somethingsnew'), isNull);
    });
  });

  group("new user", (){
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store
        ..clear()
        ..['Untitled'] = {'code': 'Test'};

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("it should not show something's new indicators", (){
      helpers.click('button', text: '☰');
      expect(query('.ice-menu li.highlighted'), isNull);
    });

    test("it should not show the something-is-new star", (){
      expect(query('#somethingsnew'), null);
    });

    group("after creating their first project", (){
      setUp((){
        helpers.click('button', text: '☰');
        helpers.click('li', text: 'New');

        helpers.typeIn('My New Project');

        helpers.click('button', text: 'Save');
      });

      test("it should not show something's new indicators", (){
        helpers.click('button', text: '☰');
        expect(query('.ice-menu li.highlighted'), isNull);
      });
    });
  });

  group("new user before default project is created", (){
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store.clear();

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("it should not show the something-is-new star", (){
      expect(query('#somethingsnew'), null);
    });
  });
}
