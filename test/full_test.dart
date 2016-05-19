part of ice_tests;

full_tests() {
  group("initial UI", (){
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

    test("the editor is full-screen", (){
      var el = document.query('#ice');
      var editor_el = el.query('.ice-code-editor-editor');
      expect(editor_el.clientWidth, window.innerWidth);
      expect(editor_el.clientHeight, closeTo(window.innerHeight,1.0));
    });

    test("does not show leave snapshot mode button", (){
      expect(
        queryAll('button'),
        helpers.elementsDoNotContain('Leave Snapshot Mode')
      );
    });
  });

  group("main toolbar", (){
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

    test("is on by default", (){
      var _test = expectAsync(
        ()=> expect(editor.content, equals('<h1>test</h1>')),
        count: 3
      );

      editor.editorReady.then(expectAsync((_){
        helpers.createProject('Project #1');

        editor.ice.onChange.listen((_)=> _test());

        editor.content = '<h1>test</h1>';
      }));
    });
  });

  group("Edit Only Mode", (){
    var editor;

    setUp((){
      editor = new Full(mode: 'edit-only')
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

    test("is enabled when the ?e query param is present", (){
      expect(editor.ice.edit_only,isTrue);
    });
  });

  group("Gaming Mode", (){
    var editor;

    setUp((){
      editor = new Full(mode: '?g')
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

    test("hides the code when the ?g query param is present", (){
      expect(
        query('.ice-code-editor-editor').style.visibility,
        equals('hidden')
      );
    });

    test("hides the show code button when the ?g query param is present", (){
      expect(
        helpers.queryWithContent('button', 'Show Code').style.display,
        equals('')
      );
    });
  });

  group("Snapshot Mode", (){
    var editor;

    setUp((){
      editor = new Full(mode: '?s')
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("is enabled when the ?s query param is present", (){
      expect(editor.store.show_snapshots, isTrue);
    });

    test("does not have a running snapshotter", (){
      expect(editor.snapshotter, isNull);
    });

    test("does not include update button", (){
      expect(
        queryAll('button'),
        helpers.elementsDoNotContain('Update')
      );
    });

    test("shows leave snapshot mode button", (){
      expect(
        helpers.queryWithContent('button', 'Leave Snapshot Mode'),
        isNotNull
      );
    });

    test("clicking leave snapshot mode button leaves snapshot mode", (){
      helpers.
        queryWithContent('button', 'Leave Snapshot Mode').
        click();

      expect(
        window.location.hash,
        ''
      );
    }, skip: "Unsure if it's possible to test this");

    test("menu only includes Open, Make a Copy, and Help", (){
      helpers.click('button', text: '☰');

      var items = queryAll('li');

      expect(
       items.map((i)=> i.text),
       ['Open', 'Make a Copy', 'Help']
      );
    });
  });


  group("Focus", (){
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

        document.
          query('#ice').
          dispatchEvent(
            new TextEvent('textInput', data: '<h1>Force Update</h1>')
          );

        helpers.click('button', text: 'Hide Code');

        var preview_ready = new Completer();
        editor.onPreviewChange.listen((e){
          preview_ready.complete();
        });
        return preview_ready.future;
      });

      test("preview has focus", (){
        expect(document.activeElement.tagName, 'IFRAME');
      });
    });
  });

  group("Import", (){
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

    final json = '''[{
        "filename":"Project #1",
        "code":"imported code",
        "lineNumber":0,
        "updated_at":"2014-01-02 00:00:00.000",
        "created_at":"2013-01-01 00:00:00.000"
      },
      {
        "filename":"Project #2",
        "code":"imported code",
        "lineNumber":0,
        "updated_at":"2014-01-01 00:00:00.000",
        "created_at":"2013-01-01 00:00:00.000"
      }]''';

    test("from JSON creates new projects", (){
      editor.import(json, 'exported_data_file.json');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      var menu_items = queryAll('li');
      expect(menu_items[0].text, 'Project #1');
    });

    test("from a regular file create a new project", (){
      editor.import('regular code', 'regular_code.txt');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      var menu_items = queryAll('li');
      expect(menu_items[0].text, 'regular_code.txt');
    });
  });

  // TODO: Need to see this fail with the undo manager commented out in
  // editor.dart before we have confidence in this test. Manually calling the
  // session's undo has no effect -- maybe using a different undoManager under
  // test?
  group("undo", (){
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store
        ..clear()
        ..['Old Project'] = {'code': 'Old Test'}
        ..['Current Project'] = {'code': 'Test'};

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("Cannot undo past the initial content", (){
      expect(editor.content, 'Test');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');
      helpers.click('li', text: 'Old Project');
      expect(editor.content, 'Old Test');

      // TODO: some combination of the following should work for this test to
      // work...
      // editor.ice.insertAt('asdf', 12);
      // editor.ice.undo();
      // editor.ice.undo();
      // editor.ice.undo();

      expect(editor.content, 'Old Test');
    });
  }, skip: true);

  // TODO: put current project title in the browser title
}
