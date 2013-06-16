part of ice_test;

open_dialog_tests() {
  group("Open Dialog", (){
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

    test("clicking the project menu item opens the project dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        queryAll('div'),
        helpers.elementsContain('Saved Projects')
      );
    });

    test("clicking the project menu item closes the main menu", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        queryAll('li'),
        helpers.elementsDoNotContain('Help')
      );
    });

    test("the escape key closes the project dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');
      helpers.hitEscape();

      expect(
        queryAll('div'),
        helpers.elementsDoNotContain(new RegExp('Saved'))
      );
    });

    test("the menu button closes the projects dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');
      helpers.click('button', text: '☰');

      expect(
        queryAll('div'),
        helpers.elementsDoNotContain('Saved Projects')
      );
    });

    test("lists project names", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('My New Project');

      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        queryAll('div'),
        helpers.elementsContain('My New Project')
      );
    });

    test("click names to switch between projects", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('Project #1');
      helpers.click('button', text: 'Save');

      editor.content = 'Code #1';
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('Project #2');
      helpers.click('button', text: 'Save');

      editor.content = 'Code #2';
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');
      helpers.click('li', text: 'Project #1');

      expect(
        editor.content,
        equals('Code #1')
      );
    });

    test("closes when a project is selected", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('Project #1');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');
      helpers.click('li', text: 'Project #1');

      expect(queryAll('li'), helpers.elementsAreEmpty);
    });


    skip_test("contains a default project on first load", (){});
  });
}
