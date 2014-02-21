part of ice_test;

new_project_dialog_tests(){
  group("New Project Dialog", (){
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

    // TODO: see keyboard shortcut tests for more realistic setup and apply same
    // approach here.
    test("new project input field has focus", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');

      expect(
        query('.ice-dialog input[type=text]'),
        equals(document.activeElement)
      );
    });

    group("after preview is rendered", (){
      setUp((){
        var preview_ready = new Completer();
        editor.onPreviewChange.listen((e){
          preview_ready.complete();
        });
        return preview_ready.future;
      });

      test("input field retains focus if nothing else happens", (){
        helpers.click('button', text: '☰');
        helpers.click('li', text: 'New');

        Timer.run(expectAsync0((){
          expect(
            document.activeElement,
            equals(query('.ice-dialog input[type=text]'))
          );
        }));
      });
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

    test("cannot have a blank name", () {
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'New');
      helpers.typeIn('  ');

      helpers.click('button', text: 'Save');

      expect(
        query('#alert').text,
        'The project name cannot be blank'
      );
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
