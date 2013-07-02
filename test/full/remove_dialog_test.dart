part of ice_test;

remove_dialog_tests() {
  group("Remove Dialog", (){
    var editor;

    setUp((){
      editor = new Full(enable_javascript_mode: false)
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store
        ..clear()
        ..['Current Project'] = {'code': 'Initial Test Code'};

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("can open the remove dialog", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');
      helpers.typeIn('My Old Project');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');
      helpers.typeIn('My New Project');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Remove');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        queryAll('li'),
        helpers.elementsDoNotContain('My New Project')
      );
    });

    test("confirms that it's ok to remove", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');
      helpers.typeIn('My Project');
      helpers.click('button', text: 'Save');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Remove');

      expect(
        query('#confirmation').text,
        matches('Are you sure you want to remove this project?')
      );
    });

    test("open previous project on remove", (){
      helpers.createProject(
        'My Old Project',
        content: "Old content",
        editor: editor
      );

      helpers.createProject(
        'My New Project',
        content: "New content",
        editor: editor
      );

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Remove');

      expect(
        editor.content,
        equals("Old content")
      );

    });

    test("open default project when no more projects exist", (){
      helpers.createProject('My New Project');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Remove');

      expect(
        editor.content,
        matches("Initial Test Code")
      );
    });
  });
}
