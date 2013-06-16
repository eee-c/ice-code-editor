part of ice_test;

new_project_dialog_tests(){
  group("New Project Dialog", (){
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

    test("new project input field has focus", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      expect(
        query('.ice-dialog input[type=text]'),
        equals(document.activeElement)
      );
    });

    test("cannot have a duplicate name", () {
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('My New Project');

      helpers.click('button', text: 'Save');

      //a duplicate
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('My New Project');

      helpers.click('button', text: 'Save');

      expect(query('#alert').
              text, equals("There is already a project with that name"));
    });

    test("can be named", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('My New Project');

      helpers.click('button', text: 'Save');

      editor.content = 'asdf';

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Save');

      // TODO: check the projects menu (once implemented)
      expect(editor.store['My New Project'], isNotNull);
      expect(editor.store['My New Project']['code'], 'asdf');
    });

    test("clicking the new menu item closes the main menu", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text:  'New');

      expect(queryAll('li'), helpers.elementsAreEmpty);
    });

    test("the escape key closes the new project dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');
      helpers.hitEscape();

      expect(
        queryAll('button'),
        helpers.elementsDoNotContain('Save')
      );
    });

    test("hitting the enter key saves", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('My New Project');
      helpers.hitEnter();

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        queryAll('div'),
        helpers.elementsContain('My New Project')
      );
    });

    test("creating a new project opens it immediately", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');
      helpers.typeIn('My Project');
      helpers.click('button', text: 'Save');
      editor.content = 'asdf';
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');
      helpers.typeIn('My New Project');
      helpers.click('button', text: 'Save');

      expect(
        editor.content,
        equals(Templates.threeD)
      );
    });

    test("has a select list of templates", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');
      expect(
        query('.ice-dialog').queryAll('option'),
        helpers.elementsArePresent
      );
    });
    test("defaults to 3D starter project", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');
      expect(
        query('.ice-dialog').queryAll('option[selected]'),
        helpers.elementsAreEmpty
      );
      expect(
        query('.ice-dialog').query('option').text,
        '3D starter project'
      );
    });
    test("can create from default template", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');
      helpers.typeIn('My Project');
      helpers.click('button', text: 'Save');

      expect(
        editor.content,
        equals(Templates.threeD)
      );
    });
    test("can create from any template", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');
      helpers.typeIn('My Project');

      query('.ice-dialog').query('select').value = 'Empty project';

      helpers.click('button', text: 'Save');

      expect(
        editor.content,
        equals(Templates.empty)
      );
    });

  });
  // TODO: blank name behavior
}
