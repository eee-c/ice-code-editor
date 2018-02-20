part of ice_test;

rename_dialog_tests() {
  group("Rename Dialog", (){
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store
        ..clear()
        ..['Untitled'] = {'code': 'Test'};

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.settings.clear();
      editor.store..clear()..freeze();
    });

    test("can open the rename dialog", (){
      helpers.click('button', text: '☰');

      helpers.click('li', text: 'New');
      helpers.typeIn('My New Project');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      expect(
        queryAll('button'),
        helpers.elementsContain('Rename')
      );
    });

    test("rename the first project as untitled", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      expect(
        query('.ice-dialog input[type=text]').value,
        equals("Untitled")
      );
    });

    test("can rename a project", (){
      helpers.click('button', text: '☰');

      helpers.click('li', text: 'New');
      helpers.typeIn('My New Project');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      helpers.typeIn('Project #1');
      helpers.click('button', text: 'Rename');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        queryAll('li'),
        helpers.elementsContain('Project #1')
      );
    });

    test("rename input field has focus", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      expect(
        query('.ice-dialog input[type=text]'),
        equals(document.activeElement)
      );
    });

    test("cannot have a duplicate name", () {
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('My Project #1');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('My Project #2');
      helpers.click('button', text: 'Save');

      //a duplicate
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      helpers.typeIn('My Project #1');
      helpers.click('button', text: 'Rename');

      expect(
        query('#alert').text,
        equals("There is already a project with that name")
      );
    });

    test("cannot have a blank name", () {
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');
      helpers.typeIn('  ');
      helpers.click('button', text: 'Rename');

      expect(
        query('#alert').text,
        equals("The project name cannot be blank")
      );
    });

    test("hitting the enter key renames", (){
      helpers.click('button', text: '☰');

      helpers.click('li', text: 'New');
      helpers.typeIn('My New Project');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      helpers.typeIn('Project #1');
      helpers.hitEnter();

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        queryAll('li'),
        helpers.elementsContain('Project #1')
      );
    });

    test("hitting the enter key does NOT add a blank line to code", (){
      helpers.click('button', text: '☰');

      helpers.click('li', text: 'New');
      helpers.typeIn('My New Project');
      helpers.click('button', text: 'Save');

      editor.content = 'asdf';

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Save');

      expect(editor.store['My New Project'], isNotNull);
      expect(editor.store['My New Project']['code'], 'asdf');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      helpers.typeIn('Project #1');
      helpers.hitEnter();

      expect(editor.store['My New Project'], isNull);
      expect(editor.store['Project #1'], isNotNull);
      expect(editor.store['Project #1']['code'], 'asdf');
    });

    test("stays active after alert", () {
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('My Project #1');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      helpers.typeIn('My Project #2');
      helpers.click('button', text: 'Save');

      //a duplicate
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      helpers.typeIn('My Project #1');
      helpers.click('button', text: 'Rename');

      expect(
        queryAll('button'),
        helpers.elementsContain('Rename')
      );
    });
  });
}
