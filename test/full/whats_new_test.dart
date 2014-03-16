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
    });

    test("links to friendly release summary", (){
      helpers.click('button', text: '☰');
      expect(query('.ice-menu a').href, contains('github'));
    });

    test("it opens in a new window", (){
      helpers.click('button', text: '☰');
      expect(query('.ice-menu a').target, '_blank');
    });

    group("existing editor, what's new hasn't been clicked", (){
      test("what's new menu item should be active", (){
        helpers.click('button', text: '☰');
        expect(query('.ice-menu a').className, contains('active'));
      });
    });

    //@TODO - when click on what's new menu item it should close the menu
    //@TODO - the star should be removed when what's new is clicked
    //@TODO - it should persist between sessions
    group("existing editor, what's new has been clicked", () {
      setUp(() {
        editor.rememberWhatsNewClicked();
      });

      test("what's new menu item should not be active", () {
        helpers.click('button', text: '☰');
        expect(query('.ice-menu a').className, isNot(contains('active')));
      });
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

    test("it should not show active indicators", (){
      helpers.click('button', text: '☰');
      expect(query('.ice-menu a').className, isNot(contains('active')));
    });

    test("it should not show the something-is-new star", (){
      expect(query('#somethingsnew'), null);
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
