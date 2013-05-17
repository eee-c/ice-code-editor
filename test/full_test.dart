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

    test("there is a modal overlay behind the dialog", (){});
    test("share link is encoded", (){});
    test("menu should close when share dialog activates", (){});
  });
}
