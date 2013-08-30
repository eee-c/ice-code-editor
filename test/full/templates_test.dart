part of ice_test;

templates_tests() {
  solo_group("default list of templates", (){
    Templates templates;

    setUp(()=> templates = new Templates());

    test("it contains three templates", (){
      expect(
        templates.length,
        3
      );
    });

    test("it orders the templates consistently", (){
      expect(
        templates.titles,
        [
          '3D starter project',
          '3D starter project (with Physics)',
          'Empty project'
        ]
      );
    });

  });

  solo_group("user-defined templates", (){
    Templates templates;
    String title, code;

    setUp(() {
      title = 'Awesome Project';
      code = 'Code for Awesome Project';

      templates = new Templates({title: code});
    });

    test("it contains only the number of templates supplied", (){
      expect(
        templates.length,
        1
      );
    });

  });

  solo_group("templates", (){
    Templates templates;

    setUp((){
      templates = new Templates({
        'Awesome Project': 'Code for Awesome Project'
      });
    });

    test("can find project by title", (){
      expect(
        templates['Awesome Project'],
        'Code for Awesome Project'
      );
    });

  });


}
