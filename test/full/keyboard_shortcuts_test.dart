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
      document.activeElement.dispatchEvent(
        new KeyboardEvent(
          'keydown',
          keyIdentifier: "n",
          ctrlKey: true
        )
      );

      expect(
        queryAll('button'),
        helpers.elementsContain('Save')
      );
    });

    group("Open Projects Dialog", (){
      test("can open the project dialog", (){
        document.activeElement.dispatchEvent(
          new KeyboardEvent(
            'keydown',
             keyIdentifier: "o",
            ctrlKey: true
          )
        );

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

    });

    test("can toggle the code editor", (){
      document.activeElement.dispatchEvent(
        new KeyboardEvent(
          'keydown',
          keyIdentifier: "e",
          ctrlKey: true
        )
      );

      expect(
        query('.ice-code-editor-editor').style.visibility,
        equals('hidden')
      );
    });

  });
}
