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

    test("Checkbox is on by default", (){
      editor.editorReady.then(expectAsync1((_){
        var button = helpers.queryWithContent("button","Update");
        var checkbox = button.query("input[type=checkbox]");
        expect(checkbox.checked, isTrue);
      }));
    });

    test("Autoupdate is set in the editor by default", (){
      editor.editorReady.then(expectAsync1((_){
        editor.onPreviewChange.listen(expectAsync1((_){
          expect(editor.ice.autoupdate, isTrue);
        }));
      }));
    });

    test("When you uncheck the checkbox autoupdate is disabled", (){

      editor.editorReady.then(expectAsync1((_){
        var button = helpers.queryWithContent("button","Update");
        var checkbox = button.query("input[type=checkbox]");

        checkbox.click();
        expect(editor.ice.autoupdate, isFalse);
      }));
    });

  });
}
