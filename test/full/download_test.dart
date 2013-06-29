part of ice_test;

download_tests() {
  group("Download", () {
    var editor;

    setUp((){
      editor = new Full(enable_javascript_mode: false)
        ..store.storage_key = "ice-test-${currentTestCase.id}";
      return editor.editorReady;
    });

  	tearDown(() {
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("it downloads the source as a file", (){
      helpers.createProject(
        "Downloadable one",
        content: "This is some content, all right.",
        editor: editor
      );

      var el = new DownloadDialog(editor).el;
      expect(el.download, equals("Downloadable one"));
      expect(el.href, startsWith("blob:"));
    });

    test("closes the main menu", () {
      helpers.createProject("My Downloadable Project");
      helpers.click('button', text: '☰');
      helpers.click('li', text: 'Download');

      expect(queryAll('li'), helpers.elementsAreEmpty);
    });
  });
}
