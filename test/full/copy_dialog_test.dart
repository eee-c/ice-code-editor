part of ice_test;

copy_dialog_tests() {
  group("Copy Dialog", (){
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

    test("hitting the enter key saves", (){
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Make a Copy');

      helpers.typeIn('My Copied Project');
      helpers.hitEnter();

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Open');

      expect(
        queryAll('div'),
        helpers.elementsContain('My Copied Project')
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

      helpers.click('button', text: '☰').then(() {
        helpers.click('li', text: 'Open').then(() {
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

   test("copied project includes copy number in parentheses", (){
     helpers.createProject('Project #1');

     helpers.click('button', text: '☰');
     helpers.click('li', text: 'Make a Copy');

     expect(
       query('.ice-dialog input[type=text]').value,
       equals("Project #1 (1)")
     );
    });

   test("project name ending in parens", (){
     helpers.createProject('projectNamedForFunction()');

     helpers.click('button', text: '☰');
     helpers.click('li', text: 'Make a Copy');

     expect(
       query('.ice-dialog input[type=text]').value,
       equals("projectNamedForFunction() (1)")
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

   test("cannot have a duplicate name", () {
     helpers.createProject('Project #1');

     //a duplicate
     helpers.click('button', text: '☰');
     helpers.click('li', text: 'Make a Copy');
     helpers.typeIn('Project #1');
     helpers.click('button', text: 'Save');

     expect(
       query('#alert').text,
       "There is already a project with that name"
     );
   });

   test("cannot have a blank name", () {
     helpers.click('button', text: '☰');
     helpers.click('li', text: 'Make a Copy');
     helpers.typeIn('  ');
     helpers.click('button', text: 'Save');

     expect(
       query('#alert').text,
       'The project name cannot be blank'
     );
   });
  });

 group('Copy Dialog in Snapshot mode', () {
   var editor;

   setUp((){
     window.location.hash = '#s';

     var store = new Store(storage_key: "ice-test-${currentTestCase.id}");
     store['SNAPSHOT: Saved Project (2014-11-03 16:58)'] = {'code': 'asdf', 'snapshot': true};

     editor = new Full()
       ..store.storage_key = "ice-test-${currentTestCase.id}";

     return editor.editorReady.then((_) {
       helpers.click('button', text: '☰');
       helpers.click('li', text: 'Make a Copy');
       helpers.typeIn('Project #1');
       helpers.click('button', text: 'Save');
     });
   });

   tearDown(() {
     editor.remove();
     editor.store..clear()..freeze();
     window.location.hash = '';
   });

   test('creates a new Project', () {
     helpers.click('button', text: '☰');
     helpers.click('li', text: 'Open');

     expect(
       queryAll('div'),
       helpers.elementsContain('Project #1')
     );
   });

   test('leaves snapshot mode', () {
     expect(
       window.location.hash,
       ''
     );
   });
 }, skip: "window.location.hash setting seems broken");
}
