part of ice_test;

share_dialog_tests() {
  group("Opening Shared Link", (){
    var editor, store;
    setUp((){
      window.location.hash = 'B/88gvT6nUUXDKT1IEAA==';
      editor = new Full(enable_javascript_mode: false);
      store = editor.store;
    });
    tearDown((){
      window.location.hash = '';
      document.query('#ice').remove();
      store.clear();
    });

    test("shared content is opened in the editor", (){
      _test(_)=> expect(editor.content, 'Howdy, Bob!');
      editor.editorReady.then(expectAsync1(_test));
    });

    test("shared project is named \"Untitled\" by default", (){
      _test(_){
        helpers.click('button', text: '☰');
        helpers.click('li', text: 'Save');

        expect(
          store['Untitled']['code'],
          'Howdy, Bob!'
        );
      }
      editor.editorReady.then(expectAsync1(_test));
    });

    test("shared project name does not clobber existing projects", (){
      store['Untitled'] = {'code': 'Hi, Fred!'};

      _test(_){
        helpers.click('button', text: '☰');
        helpers.click('li', text: 'Save');

        expect(store['Untitled']['code'], 'Hi, Fred!');
        expect(store['Untitled (1)']['code'], 'Howdy, Bob!');
      }

      editor.editorReady.then(expectAsync1(_test));
    });

    test("removes share hash", (){
      _test(_){
        expect(window.location.hash, '');
      }

      editor.editorReady.then(expectAsync1(_test));
    });
  });

  group("Share Dialog", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(()=> document.query('#ice').remove());

    test("clicking the share link shows the share dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');

      expect(
        queryAll('div'),
        helpers.elementsContain('Copy this link')
      );
    });

    test("clicking the share link closes the main menu", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');

      expect(queryAll('li'), helpers.elementsAreEmpty);
    });

    test("the menu button closes the share dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');
      helpers.click('button', text: '☰');

      expect(
        queryAll('div'),
        helpers.elementsDoNotContain('Copy this link')
      );
    });

    test("share field has focus", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');

      expect(
        query('.ice-dialog input'),
        equals(document.activeElement)
      );
    });

    test("clicking in the editor closes the share dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');

      _test(_) {
        helpers.click('.ice-code-editor-editor');

        expect(
          queryAll('div'),
          helpers.elementsDoNotContain('Copy this link')
        );
      };
      editor.editorReady.then(expectAsync1(_test));

    });
  });
}
