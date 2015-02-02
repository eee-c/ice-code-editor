part of ice_test;

whats_new_tests() {
  group("What's New Menu Item", (){
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

    // START HERE! One ICE is locked alert is sticking around from
    // somewhere. We need to find and eliminate it.

    // The previous test failures were caused by the editor lock reading from
    // the default settings before we changed the settings localStorage
    // key. This is a lock bleeding through from some other test (see below) so
    // the editor.lock was true. The test then changed the localStorage key
    // (which would be useful for these tests), so that when tearDown reset the
    // settings, it was resetting the per-test settings, not the default setting
    // that retained the lock.

    // May also want to improve the setup of the settings in this code. Might be
    // nice to have new settings key for each test (like the data store), but
    // would then need a mechanism to reset the lock since it would already
    // think an existing lock is present.

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
        ..settings['clicked_whats_new'] = true;

      editor.store
        ..clear()
        ..['Untitled'] = {'code': 'Test'};

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
      editor.settings..clear();
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
      editor.settings..clear();
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
      editor.settings..clear();
      editor.store..clear()..freeze();
    });

    test("it should not show the something-is-new star", (){
      expect(query('#somethingsnew'), null);
    });
  });
}
