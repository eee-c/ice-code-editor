part of ice_test;

open_dialog_tests() {
  group("Open Dialog", (){
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

  group("Open Dialog Filter", (){
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store.clear();
      new Iterable.generate(12, (i){
        editor.store['Project ${i}'] = {'code': 'code ${i}'};
      }).toList();

      return editor.editorReady;
    });
    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("is not visible when there are fewer than 10 projects", (){
      editor.store.clear();
      new Iterable.generate(9, (i){
        editor.store['Project ${i}'] = {'code': 'code ${i}'};
      }).toList();

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        queryAll('.ice-menu input'),
        helpers.elementsAreEmpty
      );
    });
    test("is visible when there are 10 or more projects", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        queryAll('.ice-menu input'),
        helpers.elementsArePresent
      );
    });
    test("has focus by default", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        query('.ice-menu input'),
        document.activeElement
      );
    });
    test("can filter projects", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      document.activeElement
        ..dispatchEvent(
            new TextEvent('textInput', data: '1')
          )
        ..dispatchEvent(
            new KeyboardEvent('keyup')
          );

      expect(
        queryAll('.ice-menu li').length,
        3
      );
    });
    test("is not case sensitive", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      document.activeElement
        ..dispatchEvent(
            new TextEvent('textInput', data: 'project 1')
          )
        ..dispatchEvent(
            new KeyboardEvent('keyup')
          );

      expect(
        queryAll('.ice-menu li').length,
        3
      );
    });
    test("updates on new text input", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      document.activeElement
        ..dispatchEvent(
            new TextEvent('textInput', data: 'project 1')
          )
        ..dispatchEvent(
            new KeyboardEvent('keyup')
          );

      expect(
        queryAll('.ice-menu li').length,
        3
      );

      document.activeElement
        ..dispatchEvent(
            new TextEvent('textInput', data: '1')
          )
        ..dispatchEvent(
            new KeyboardEvent('keyup')
          );

      expect(
        queryAll('.ice-menu li').length,
        1
      );
    });
    test("shows message when no projects match", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      document.activeElement
        ..dispatchEvent(
            new TextEvent('textInput', data: 'asdf')
          )
        ..dispatchEvent(
            new KeyboardEvent('keyup')
          );

      expect(
        query('.ice-menu li').text,
        contains('No matching projects')
      );
    });
  });

  group("Switching Between Projects", (){
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

    test("restores previous line number", (){
      editor.content = '''
Code line 01
Code line 02
Code line 03
Code line 04
Code line 05
Code line 06
Code line 07
''';

      editor.lineNumber = 6;

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Save');

      editor.store
        ..['Other Project'] = {'code': 'Test'};

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');
      helpers.click('li', text: 'Other Project');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');
      helpers.click('li', text: 'Current Project');

      expect(editor.lineNumber, 6);
    });

  });
}
