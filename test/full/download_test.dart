part of ice_test;

//TODO: implement separate stores for each test, because a shared store does not get cleaned up at all.
download_tests() {
  group("Download", () {
  	tearDown(() {
      document.query('#ice').remove();
      new Store().clear();
    });

    //TODO: why does this fail as a solo test?
    test("it downloads the source as a file", (){
      var editor = new Full(enable_javascript_mode: false);
      _test(_) {
        helpers.createProject("Downloadable one", 
	       content: "This is some content, all right.",
	       editor: editor);

	       helpers.click('button', text: '☰');
         var el = helpers.queryWithContent("a", "Download");
	       expect(el, isNotNull);
	       expect(el.download, equals("Downloadable one"));
	       expect(el.href, startsWith("blob:"));
      }
      editor.editorReady.then(expectAsync1(_test));
    });
    test("closes the main menu", () {
      var editor = new Full(enable_javascript_mode: false);
      _test(_) {
        helpers.createProject("Downloadable two");
        helpers.click('button', text: '☰');
        helpers.click('a', text: 'Download');
        expect(queryAll('li'), helpers.elementsAreEmpty);
      }
      editor.editorReady.then(expectAsync1(_test));
    });
  });
}