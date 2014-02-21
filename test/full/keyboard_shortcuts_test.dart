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


    group("opening the new dialog", (){
      setUp((){
        var preview_ready = new Completer();
        editor.onPreviewChange.listen((e){
          preview_ready.complete();
        });
        return preview_ready.future;
      });

      test("can open the new dialog", (){
        helpers.typeCtrl('n');
        expect(
          queryAll('button'),
          helpers.elementsContain('Save')
        );
      });

      test("opening new project gives input field focus", (){
        helpers.typeCtrl('n');

        var wait = new Duration(milliseconds: 500);
        new Timer(wait, expectAsync0((){
          expect(
            document.activeElement,
            equals(query('.ice-dialog input[type=text]'))
          );
        }));
      });
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

      test("down arrow key moves forward in list", (){
        helpers.typeCtrl('O');
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

      test("up arrow at top of list moves back into filter", (){
        helpers.typeCtrl('o');
        helpers.typeIn('project 1');
        // *filter*
        // project 11
        // project 10
        // project 1

        helpers.arrowDown();
        helpers.arrowUp();

        expect(
          document.activeElement.tagName,
          'INPUT'
        );
      });

      group("With Less Than 10 Projects", (){
        setUp((){
          editor.store
            ..remove('Project 2')
            ..remove('Project 3')
            ..remove('Project 4')
            ..remove('Project 5')
            ..remove('Project 6')
            ..remove('Project 7');
        });
        test("first project has keyboard focus", (){
          helpers.typeCtrl('o');
          // Current Project
          // Old Project
          // project 11
          // ...

          expect(
            document.activeElement.text,
            equals('Current Project')
          );
        });

        test("up arrow at top of list stays at top of list", (){
          helpers.typeCtrl('o');
          // Current Project
          // Old Project
          // project 11
          // ...
          helpers.arrowUp();

          expect(
            document.activeElement.text,
            equals('Current Project')
          );
        });

        test("down arrow at bottom of list stays at bottom of list", (){
          helpers.typeCtrl('O');
          // Current Project
          // Old Project
          // project 11
          // ...
          helpers.arrowDown(11);

          expect(
            document.activeElement.text,
            equals('Project 0')
          );
        });
      });
    });

    test("opening project dialog after new dialog closes the first", (){
      helpers.typeCtrl('N');
      helpers.typeCtrl('O');

      expect(
        queryAll('button'),
        helpers.elementsDoNotContain('Save')
      );
    });

    test("opening new dialog after open dialog closes the first", (){
      helpers.typeCtrl('O');
      helpers.typeCtrl('N');

      expect(
        queryAll('div'),
        helpers.elementsDoNotContain('Saved Projects')
      );
    });

    test("toggling code after new dialog closes the dialog", (){
      helpers.typeCtrl('N');
      helpers.typeCtrlShift('H');

      expect(
        queryAll('button'),
        helpers.elementsDoNotContain('Save')
      );
    });
  });

  group("Toggling the code editor", (){
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      editor.store.clear();

      editor.store
        ..['Old Project'] = {'code': 'Old'}
        ..['Current Project'] = {'code': 'Current'};

      return editor.editorReady;
    });

    tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("with hotkey", (){
      helpers.typeCtrlShift('H');
      expect(
        query('.ice-code-editor-editor').style.visibility,
        'hidden'
      );
    });

    test("with post message", () {
      var url = new RegExp(r'^file://').hasMatch(window.location.href)
        ? '*': window.location.href;
      editor.hideCode();
      window.postMessage('showCode', url);
      Timer.run(expectAsync0( () {
        expect(
          query('.ice-code-editor-editor').style.visibility,
          'visible'
        );
      }));
    });
  });
}
