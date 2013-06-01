part of ice_test;

rename_dialog_tests() {
  group("Rename Dialog", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      new Store().clear();
    });

    test("can open the rename dialog", (){
      helpers.click('button', text: '☰');

      helpers.click('li', text: 'New');
      query('input[type=text]').value = 'My New Project';
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
      query('input[type=text]').value = 'My New Project';
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      query('input[type=text]').value = 'Project #1';
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

      query('input[type=text]').value = 'My Project #1';
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      query('input[type=text]').value = 'My Project #2';
      helpers.click('button', text: 'Save');

      //a duplicate
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      query('input[type=text]').value = 'My Project #1';
      helpers.click('button', text: 'Rename');

      expect(
        query('#alert').text,
        equals("There is already a project with that name")
      );
    });

    test("hitting the enter key renames", (){
      helpers.click('button', text: '☰');

      helpers.click('li', text: 'New');
      query('input[type=text]').value = 'My New Project';
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      query('input[type=text]').value = 'Project #1';
      helpers.hitEnter();

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        queryAll('li'),
        helpers.elementsContain('Project #1')
      );
    });

    test("stays active after alert", () {
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      query('input[type=text]').value = 'My Project #1';
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      query('input[type=text]').value = 'My Project #2';
      helpers.click('button', text: 'Save');

      //a duplicate
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      query('input[type=text]').value = 'My Project #1';
      helpers.click('button', text: 'Rename');

      expect(
        queryAll('button'),
        helpers.elementsContain('Rename')
      );
    });
  });
}
