part of ice_test;

share_dialog_tests() {
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

    skip_test("share link is encoded", (){});

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
