part of ice_test;

editor_tests() {
  group("defaults", () {
    setUp(() {
      var el = new Element.html('<div id=ice-${currentTestCase.id}>');
      document.body.nodes.add(el);
    });
    tearDown(() {
      var el = document.query('#ice-${currentTestCase.id}');
      document.body.nodes.remove(el);
    });

    test("defaults to auto-update the preview", () {
      var it = new Editor('#ice-${currentTestCase.id}', enable_javascript_mode: false);
      expect(it.autoupdate, equals(true));
      expect(it.editorReady, completes);
    });

    test("starts an ACE instance", (){
      var it = new Editor('#ice-${currentTestCase.id}', enable_javascript_mode: false);
      it.editorReady.then(
        expectAsync1((_) {
          expect(document.query('.ace_content'), isNotNull);
        })
      );
    });

    test("defaults to disable edit-only mode", () {
      var it = new Editor('#ice-${currentTestCase.id}', enable_javascript_mode: false);
      expect(it.edit_only, equals(false));
      expect(it.editorReady, completes);
    });

  });

  group("content", () {
    setUp(() {
      var el = new Element.html('<div id=ice-${currentTestCase.id}>');
      document.body.nodes.add(el);
    });
    tearDown(() {
      var el = document.query('#ice-${currentTestCase.id}');
      document.body.nodes.remove(el);
    });

    test("can set the content", () {
      var it = new Editor('#ice-${currentTestCase.id}', enable_javascript_mode: false);

      it.content = 'asdf';

      it.editorReady.then(
        expectAsync1((_) {
          expect(it.content, equals('asdf'));
        })
      );

    });
  });
}
