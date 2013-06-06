part of ice_test;

copy_dialog_tests() {
  group("Copy Dialog", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      new Store().clear();
    });

    test("can open copy dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Make a Copy');

      expect(
        queryAll('button'),
        helpers.elementsContain('Save')
      );
    });

    test("project name field has focus", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Make a Copy');

      expect(
        query('.ice-dialog input[type=text]'),
        equals(document.activeElement)
      );
    });

    test("works with existing projects", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('Project #1');
      helpers.click('button', text: 'Save');

      editor.content = 'Code #1';
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Make a Copy');

      helpers.typeIn('Copy of Project #1');
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

      helpers.click('button', text: '☰').then((){
        helpers.click('li', text: 'Open').then((){
          helpers.click('li', text: 'Copy of Project #1');
        });
      });

      expect(
        editor.content,
        equals('Code #2')
      );
    });

    test("project name field is pre-populated", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('Project #1');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Make a Copy');

      expect(
        query('.ice-dialog input[type=text]').value,
        equals("Project #1 (1)")
      );
     });

    test("project name field is pre-populated", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('Foo');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Make a Copy');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');
      helpers.click('li', text: 'Foo');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Make a Copy');

      expect(
        query('.ice-dialog input[type=text]').value,
        equals("Foo (2)")
      );
    });

    test("project name field is incremented with multiple tests", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('Project #1');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Make a Copy');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Make a Copy');

      expect(
        query('.ice-dialog input[type=text]').value,
        equals("Project #1 (2)")
      );
    });

  });

  // TODO: save on enter
}
