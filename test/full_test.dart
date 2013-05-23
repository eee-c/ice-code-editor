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
      var menu_button = queryAll('button').
        firstWhere((e)=> e.text=='☰');

      menu_button.click();
      var menu = queryAll('li').
        firstWhere((e)=> e.text.contains('Help'));

      expect(menu, isNotNull);
    });

    test("clicking the menu button a second time hides the menu", (){
      var menu_button = queryAll('button').
        firstWhere((e)=> e.text=='☰');

      menu_button.click();

      expect(queryAll('li').map((e)=> e.text), contains('Help'));

      menu_button.click();

      expect(queryAll('li').map((e)=> e.text), isEmpty);
    });
  });

  group("sharing", (){
    setUp(()=> new Full(enable_javascript_mode: false));
    tearDown(()=> document.query('#ice').remove());

    test("clicking the share link shows the share dialog", (){
      queryAll('button').
        firstWhere((e)=> e.text=='☰').
        click();

      queryAll('li').
        firstWhere((e)=> e.text=='Share').
        click();

      expect(
        queryAll('div').map((e)=> e.text).toList(),
        contains(matches('Copy this link'))
      );
    });

    skip_test("there is a modal overlay behind the dialog", (){});
    skip_test("share link is encoded", (){});
    skip_test("menu should close when share dialog activates", (){});
  });

  group("project menu", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      new Store().clear();
    });

    test("clicking the project menu item opens the project dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Projects');

      expect(
        queryAll('div'),
        helpers.elements_contain('Saved Projects')
      );
    });

    test("clicking the project menu item closes the main menu", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Projects');

      expect(
        queryAll('li').map((e)=> e.text).toList(),
        isNot(contains(matches('Help')))
      );
    });

    test("the escape key closes the project dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Projects');

      document.body.dispatchEvent(
        new KeyboardEvent(
          'keyup',
          keyIdentifier: new String.fromCharCode(27)
        )
      );

      expect(
        queryAll('div').map((e)=> e.text).toList(),
        isNot(contains(matches(new RegExp('Saved'))))
      );
    });

    test("the menu button closes the projects dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Projects');
      helpers.click('button', text: '☰');

      expect(
        queryAll('div'),
        isNot(contains(matches('Saved Projects')))
      );
    });

    test("lists project names", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      query('input').value = 'My New Project';

      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Projects');

      expect(
        queryAll('div'),
        helpers.elements_contain('My New Project')
      );
    });

    test("click names to switch between projects", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      query('input').value = 'Project #1';
      helpers.click('button', text: 'Save');

      editor.content = 'Code #1';
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      query('input').value = 'Project #2';
      helpers.click('button', text: 'Save');

      editor.content = 'Code #2';
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Projects');
      helpers.click('li', text: 'Project #1');

      expect(
        editor.content,
        equals('Code #1')
      );
    });

    test("closes when a project is selected", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      query('input').value = 'Project #1';
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Projects');
      helpers.click('li', text: 'Project #1');

      expect(queryAll('li').map((e)=> e.text).toList(), isEmpty);
    });


    skip_test("contains a default project on first load", (){});
  });

  group("new project", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      new Store().clear();
    });

    test("can be named", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      query('input').value = 'My New Project';

      helpers.click('button', text: 'Save');

      editor.content = 'asdf';

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Save');

      // TODO: check the projects menu (once implemented)
      var store = new Store();
      expect(store['My New Project'], isNotNull);
      expect(store['My New Project']['code'], 'asdf');
    });

    test("clicking the new menu item closes the main menu", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text:  'New');

      expect(queryAll('li').map((e)=> e.text).toList(), isEmpty);
    });

  });

  group("saving projects", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      new Store().clear();
    });

    test("a saved project is loaded when the editor starts", (){
      editor.content = 'asdf';

      queryAll('button').
        firstWhere((e)=> e.text=='☰').
        click();

      queryAll('li').
        firstWhere((e)=> e.text=='Save').
        click();

      document.query('#ice').remove();
      editor = new Full(enable_javascript_mode: false);

      _test(_) {
        expect(editor.content, equals('asdf'));
      };
      editor.editorReady.then(expectAsync1(_test));
    });

    test("clicking save closes the main menu", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text:  'Save');

      expect(queryAll('li').map((e)=> e.text).toList(), isEmpty);
    });

    skip_test("", (){});
  });
}
