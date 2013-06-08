part of ice_tests;

full_tests() {
  group("initial UI", (){
    tearDown(()=> document.query('#ice').remove());

    test("the editor is full-screen", (){
      var it = new Full(enable_javascript_mode: false);

      _test(_) {
        var el = document.query('#ice');
        var editor_el = el.query('.ice-code-editor-editor');
        expect(editor_el.clientWidth, window.innerWidth);
        expect(editor_el.clientHeight, closeTo(window.innerHeight,1.0));
      };
      it.editorReady.then(expectAsync1(_test));
    });

    //test("has a default project", (){});
  });

  group("main toolbar", (){
    setUp(()=> new Full(enable_javascript_mode: false));
    tearDown(()=> document.query('#ice').remove());

    test("it has a menu button", (){
      var buttons = document.queryAll('button');
      expect(buttons.any((e)=> e.text=='☰'), isTrue);
    });

    test("clicking the menu button brings up the menu", (){
      helpers.click('button', text: '☰');

      var menu = queryAll('li').
        firstWhere((e)=> e.text.contains('Help'));

      expect(menu, isNotNull);
    });

    test("clicking the menu button a second time hides the menu", (){
      helpers.click('button', text: '☰');
      expect(queryAll('li'), helpers.elementsContain('Help'));

      helpers.click('button', text: '☰');
      expect(queryAll('li'), helpers.elementsAreEmpty);
    });
  });

  group("Auto Save", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      editor.store.clear();
    });

    skip_test("is on by default", (){
      _test(_) {
        helpers.createProject('Test Project');
        editor.content = '<h1>test</h1>';

        expect(
          editor.store['Test Project']['code'],
          equals('<h1>test</h1>')
        );
      }

      editor.editorReady.then(expectAsync1(_test));
    });

    skip_test("is on by default (original)", (){
      editor.store.storageKey = "codeeditor-${currentTestCase.id}";
      helpers.createProject('Test Project');
      editor.content = '&lt;h1>test&lt;/h1>';

      expect(
        editor.store['Test Project']['code'],
        equals('&lt;h1>test&lt;/h1>')
      );
    });

  });

  // TODO: put current project title in the browser title
}
