part of ice_test;

image_upload_tests() {
  group("Image Upload Dialog", () {
    var editor;

    setUp((){
      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      return editor.editorReady;
    });

  	tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("First imported project should be at the top of project list", (){
      var dialog = new ImageUplaodDialog(editor)
        ..import('asdf', 'asdf.png');

      helpers.click('button', text: '☰');
      helpers.click('li', text: 'List Uploaded Images');
      var menu_items = queryAll('li');
      expect(menu_items[0].text, '/3de/adsf.png');
    });
  });
}