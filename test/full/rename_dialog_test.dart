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
      query('input').value = 'My New Project';
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
        query('.ice-dialog input').value,
        equals("Untitled")
      );
    });

    test("can rename a project", (){
      helpers.click('button', text: '☰');

      helpers.click('li', text: 'New');
      query('input').value = 'My New Project';
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      query('input').value = 'Project #1';
      helpers.click('button', text: 'Rename');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        queryAll('li'),
        helpers.elementsContain('Project #1')
      );
    });

    // the rename input field has focus
    test("rename input field has focus", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Rename');

      expect(
        query('.ice-dialog input'),
        equals(document.activeElement)
      );
    });

    // alerts the user if renaming duplicates an existing project
  });
}
