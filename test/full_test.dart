part of ice_tests;

full_tests() {
  group("initial UI", (){
    var editor;

    setUp((){
      editor = new Full(enable_javascript_mode: false)
        ..store.storage_key = "ice-test-${currentTestCase.id}";
      return editor.editorReady;
    });

    tearDown(() {
      document.query('#ice').remove();
      editor.store..clear()..freeze();
    });

    test("the editor is full-screen", (){
      var el = document.query('#ice');
      var editor_el = el.query('.ice-code-editor-editor');
      expect(editor_el.clientWidth, window.innerWidth);
      expect(editor_el.clientHeight, closeTo(window.innerHeight,1.0));
    });

    //test("has a default project", (){});
  });

  group("main toolbar", (){
    var editor;

    setUp((){
      editor = new Full(enable_javascript_mode: false)
        ..store.storage_key = "ice-test-${currentTestCase.id}";
      return editor.editorReady;
    });

    tearDown(() {
      document.query('#ice').remove();
      editor.store..clear()..freeze();
    });

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

    setUp((){
      editor = new Full(enable_javascript_mode: false)
        ..store.storage_key = "ice-test-${currentTestCase.id}";
      return editor.editorReady;
    });

    tearDown(() {
      document.query('#ice').remove();
      editor.store..clear()..freeze();
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

    setUp((){
      window.location.hash = '#e';

      editor = new Full(enable_javascript_mode: false)
        ..store.storage_key = "ice-test-${currentTestCase.id}";
      return editor.editorReady;
    });

    tearDown(() {
      document.query('#ice').remove();
      editor.store..clear()..freeze();
      window.location.hash = '';
    });

    test("is enabled when the ?e query param is present", (){
      expect(editor.ice.edit_only,isTrue);
    });
  });

  group("Gaming Mode", (){
    var editor;

    setUp((){
      window.location.hash = '#g';
      editor = new Full(enable_javascript_mode: false)
        ..store.storage_key = "ice-test-${currentTestCase.id}";
      return editor.editorReady;
    });

    tearDown(() {
      document.query('#ice').remove();
      editor.store..clear()..freeze();
      window.location.hash = '';
    });

    test("is enabled when the ?g query param is present", (){
      expect(
        query('.ice-code-editor-editor').style.visibility,
        equals('hidden')
      );
    });

    test("is enabled when the ?g query param is present", (){
      expect(
        helpers.queryWithContent('button', 'Show Code').style.display,
        equals('')
      );
    });
  });

  group("Focus", (){
    var editor;

    setUp((){
      editor = new Full(enable_javascript_mode: false)
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      var preview_ready = new Completer();
      editor.onPreviewChange.listen((e){
        if (preview_ready.isCompleted) return;
        preview_ready.complete();
      });
      return preview_ready.future;
    });

    tearDown(() {
      document.query('#ice').remove();
      editor.store..clear()..freeze();
    });

    test("editor has focus after closing a dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Make a Copy');
      helpers.hitEscape();

      var el = document.
        query('.ice-code-editor-editor').
        query('textarea.ace_text-input');

      expect(document.activeElement, el);
    });

    group("hiding code after update", (){
      setUp((){
        editor.ice.focus();
        editor.content = '<h1>Force Update</h1>';
        helpers.click('button', text: 'Hide Code');

        var preview_ready = new Completer();
        editor.onPreviewChange.listen((e){
          preview_ready.complete();
        });
        return preview_ready.future;
      });

      test("preview has focus", (){
        var el = document.query('iframe');

        expect(document.activeElement, el);
      });
    });
  });

  // TODO: put current project title in the browser title
}
