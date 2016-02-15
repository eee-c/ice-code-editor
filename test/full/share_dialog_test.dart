part of ice_test;

share_dialog_tests() {
  group("Opening Shared Link", (){
    var editor, store;

    setUp((){
      window.location.hash = 'B/88gvT6nUUXDKT1IEAA==';

      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      store = editor.store
        ..clear()
        ..['Current Project'] = {'code': 'Test'};

      return editor.editorReady;
    });

    tearDown((){
      window.location.hash = '';
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("shared content is opened in the editor", (){
      expect(editor.content, 'Howdy, Bob!');
    });

    test("shared project is named \"Untitled\" by default", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Save');

      expect(
        store['Untitled']['code'],
        'Howdy, Bob!'
      );
    });

    test("removes share hash", (){
      expect(window.location.hash, '');
    });

  }, skip: "window.location.hash setting seems broken");
  // Note: Cannot test the combination of ?g and #B
  // because the search parameter reload the test page,
  // which restarts the test suite. For now we rely on the individual tests.

  group("Opening Shared Link with an existing untitled project", (){
    var editor, store;

    setUp((){
      window.location.hash = 'B/88gvT6nUUXDKT1IEAA==';

      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}"
        ..store['Untitled'] = {'code': 'Hi, Fred!'};

      store = editor.store;

      return editor.editorReady;
    });


    tearDown((){
      window.location.hash = '';
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("does not clobber the existing project", (){
        helpers.click('button', text: '☰');
        helpers.click('li', text: 'Save');

        expect(store['Untitled']['code'], 'Hi, Fred!');
        expect(store['Untitled (1)']['code'], 'Howdy, Bob!');
    });
  }, skip: "window.location.hash setting seems broken");

  group("Share Dialog", (){
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

    test("clicking the share link shows the share dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');

      expect(
        queryAll('div'),
        helpers.elementsContain('Copy this link')
      );
    });

    test("share dialog contains a game mode checkbox", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');

      expect(
        queryAll('.ice-dialog label'),
        helpers.elementsContain('start in game mode')
      );
      expect(
        queryAll('.ice-dialog label input[type=checkbox]'),
        helpers.elementsArePresent
      );
    });
    test("share dialog has a link to a URL shortener", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');
      expect(query('.ice-dialog a'), isNotNull);
    });

    test("share dialog's URL shortener points to is.gd", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');
      expect(query('.ice-dialog a').href, contains('is.gd'));
    });

    test("share dialog's URL shortener href link is properly encoded", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');
      expect(
        query('.ice-dialog a').href,
        contains('url=http%3A%2F%2Fgamingjs.com%2Fice%2F%23B%2FC0ktLgEA')
      );
    });

    test("clicking the game mode checkbox adds game mode to link", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');
      helpers.click('.ice-dialog label input[type=checkbox]');

      expect(
        query('.ice-dialog input').value,
        matches('\\?g')
      );
    });

    test("share dialog's shortened URL include game-only mode (if set)", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');
      helpers.click('.ice-dialog label input[type=checkbox]');
      expect(
        query('.ice-dialog a').href,
        contains('url=http%3A%2F%2Fgamingjs.com%2Fice%2F%3Fg%23B%2FC0ktLgEA')
      );
    });

    test("clicking the game mode twice removes game mode from link", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Share');
      helpers.click('.ice-dialog label input[type=checkbox]');
      helpers.click('.ice-dialog label input[type=checkbox]');

      expect(
        query('.ice-dialog input').value,
        isNot(matches('\\?g'))
      );
    });

    // input has focus after game mode is clicked
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

      helpers.click('.ice-code-editor-editor');

      expect(
        queryAll('div'),
        helpers.elementsDoNotContain('Copy this link')
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
  });
}
