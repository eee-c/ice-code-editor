part of ice_test;

new_project_dialog_tests(){
  group("New Project Dialog", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      new Store().clear();
    });

    test("new project input field has focus", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      expect(
        query('.ice-dialog input'),
        equals(document.activeElement)
      );
    });

    test("cannot have a duplicate name", () {
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      query('input').value = 'My New Project';

      helpers.click('button', text: 'Save');

      //a duplicate
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      query('input').value = 'My New Project';

      helpers.click('button', text: 'Save');

      expect(query('#alert').
              text, equals("There is already a project with that name"));
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

      expect(queryAll('li'), helpers.elementsAreEmpty);
    });

    test("the escape key closes the new project dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      document.body.dispatchEvent(
        new KeyboardEvent(
          'keyup',
          keyIdentifier: new String.fromCharCode(27)
        )
      );

      expect(
        queryAll('button'),
        helpers.elementsDoNotContain('Save')
      );
    });

    test("hitting the enter key saves", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      query('input').value = 'My New Project';
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
      query('input').value = 'My Project';
      helpers.click('button', text: 'Save');
      editor.content = 'asdf';
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');
      query('input').value = 'My New Project';
      helpers.click('button', text: 'Save');

      expect(
        editor.content,
        equals('')
      );
    });
  });
  // TODO: templates
  // TODO: blank name behavior
}
