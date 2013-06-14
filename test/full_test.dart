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

    test("is on by default", (){
      var _test = expectAsync0(
        ()=> expect(editor.content, equals('<h1>test</h1>')),
        count: 3
      );

      editor.editorReady.then((_){
        helpers.createProject('Project #1');

        editor.ice.onChange.listen((_)=> _test());

        editor.content = '<h1>test</h1>';
      });
    });
  });

  group("Edit Only Mode", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      editor.store.clear();
      window.location.hash = '';
    });

    test("is enabled when the ?e query param is present", (){
      window.location.hash = '#e';

      _test(_) {
        expect(
          editor.ice.edit_only,
          isTrue
        );
      }

      editor.editorReady.then(expectAsync1(_test));
    });
  });

  group("Gaming Mode", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      editor.store.clear();
      window.location.hash = '';
    });

    test("is enabled when the ?g query param is present", (){
      window.location.hash = '#g';

      _test(_) {
        expect(
          query('.ice-code-editor-editor').style.visibility,
          equals('hidden')
        );
      }

      editor.editorReady.then(expectAsync1(_test));
    });

    test("is enabled when the ?g query param is present", (){
      window.location.hash = '#g';

      _test(_) {
        expect(
          helpers.queryWithContent('button', 'Show Code').style.display,
          equals('')
        );
      }

      editor.editorReady.then(expectAsync1(_test));
    });
  });

  // TODO: put current project title in the browser title
}
