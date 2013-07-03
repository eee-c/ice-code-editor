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
      var it = new Editor('#ice-${currentTestCase.id}');
      expect(it.autoupdate, equals(true));
      expect(it.editorReady, completes);
    });

    test("starts an ACE instance", (){
      var it = new Editor('#ice-${currentTestCase.id}');
      it.editorReady.then(
        expectAsync1((_) {
          expect(document.query('.ace_content'), isNotNull);
        })
      );
    });

    test("defaults to disable edit-only mode", () {
      var it = new Editor('#ice-${currentTestCase.id}');
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
      var it = new Editor('#ice-${currentTestCase.id}');

      it.content = 'asdf';

      it.editorReady.then(
        expectAsync1((_) {
          expect(it.content, equals('asdf'));
        })
      );

    });
  });

  group("focus", (){
    var editor;

    setUp((){
      document.body.nodes.
        add(new Element.html('<div id=ice-${currentTestCase.id}>'));

      editor = new Editor('#ice-${currentTestCase.id}');

      editor.content = '<h1>preview</h1>';

      var preview_ready = new Completer();
      editor.onPreviewChange.listen((e){
        if (preview_ready.isCompleted) return;
        preview_ready.complete();
      });
      return preview_ready.future;
    });

    tearDown(()=> document.body.nodes.
        remove(document.query('#ice-${currentTestCase.id}')));

    test('code is visibile by default', (){
      var el = document.
        query('#ice-${currentTestCase.id}').
        query('.ice-code-editor-editor');

      expect(el.style.visibility, isNot('hidden'));
    });

    test('focus goes to code if code is visibile', (){
      var el = document.
        query('#ice-${currentTestCase.id}').
        query('.ice-code-editor-editor').
        query('textarea.ace_text-input');

      expect(document.activeElement, el);
    });

    test('focus goes to preview if code is hidden', (){
      editor.hideCode();

      var el = document.
        query('#ice-${currentTestCase.id}').
        query('iframe');

      expect(document.activeElement, el);
    });

    group("hide code after an update", (){
      setUp((){
        editor.focus();
        editor.content = '<h1>Force Update</h1>';
        editor.hideCode();

        var preview_ready = new Completer();
        editor.onPreviewChange.listen((e){
          if (preview_ready.isCompleted) return;
          preview_ready.complete();
        });
        return preview_ready.future;
      });

      test('focus goes to preview if code is hidden', (){
        var el = document.
          query('#ice-${currentTestCase.id}').
          query('iframe');

        expect(document.activeElement, el);
      });
    });

    // focus goes to preview if code is hidden
    // focus goes to preview after update if code is hidden
  });
}
