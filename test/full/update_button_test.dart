part of ice_test;

update_button_tests() {
  group("Update Button", (){
    var editor;

    setUp(()=> editor = new Full(enable_javascript_mode: false));
    tearDown(() {
      document.query('#ice').remove();
      new Store().clear();
    });

    test("updates the preview layer", (){
      helpers.createProject("My Project");
      editor.content = "<h1>Hello</h1>";

      editor.onPreviewChange.listen(expectAsync1((_)=> true));

      helpers.click('button', text: " Update");
    });
  });
}
