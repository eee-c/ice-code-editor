part of ice_test;

keyboard_shortcuts_tests() {
  group("Keyboard Shortcuts", (){
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store.clear();

      new Iterable.generate(12, (i){
        editor.store['Project ${i}'] = {'code': 'code ${i}'};
      }).toList();

      editor.store
        ..['Old Project'] = {'code': 'Old'}
        ..['Current Project'] = {'code': 'Current'};

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("can open the new dialog", (){
      helpers.typeCtrl('n');
      expect(
        queryAll('button'),
        helpers.elementsContain('Save')
      );
    });

    group("Open Projects Dialog", (){
      test("can open the project dialog", (){
        helpers.typeCtrl("o");
        expect(
          queryAll('div'),
          helpers.elementsContain('Saved Projects')
        );
      });

      test("hitting enter with no filter text does nothing", (){
        helpers.typeCtrl('o');
        helpers.hitEnter();

        expect(
          editor.content,
          equals('Current')
        );
      });

      test("enter opens the top project", (){
        helpers.typeCtrl('o');
        helpers.typeIn('old');
        helpers.hitEnter();

        expect(
          editor.content,
          equals('Old')
        );
      });

      test("tab key moves forward in list", (){
        helpers.typeCtrl('o');
        helpers.typeIn('old');

        expect(
          queryAll('li').where((e)=> e.tabIndex==0).first.text,
          equals('Old Project')
        );
      });

      test("donw arrow key moves forward in list", (){
        helpers.typeCtrl('o');
        helpers.typeIn('project 1');
        // project 11
        // project 10 *
        // project 1

        helpers.arrowDown(2);

        expect(
          document.activeElement.text,
          equals('Project 10')
        );
      });

      test("up arrow key moves backward in list", (){
        helpers.typeCtrl('o');
        helpers.typeIn('project 1');
        // project 11
        // project 10 *
        // project 1

        helpers.arrowDown(3);
        helpers.arrowUp();

        expect(
          document.activeElement.text,
          equals('Project 10')
        );
      });
    });

    test("can toggle the code editor", (){
      document.activeElement.dispatchEvent(
        new KeyboardEvent(
          'keydown',
          keyIdentifier: "h",
          ctrlKey: true,
          shiftKey: true
        )
      );

      expect(
        query('.ice-code-editor-editor').style.visibility,
        equals('hidden')
      );
    });

  });
}
