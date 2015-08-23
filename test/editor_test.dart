part of ice_test;

editor_tests() {
  group("defaults", () {
    var el;
    setUp(() {
      el = new Element.html('<div>');
      document.body.nodes.add(el);
    });
    tearDown(()=> el.remove());

    test("defaults to auto-update the preview", () {
      var it = new Editor(el);
      expect(it.autoupdate, equals(true));
      expect(it.editorReady, completes);
    });

    test("starts an ACE instance", (){
      var it = new Editor(el);
      it.editorReady.then(
        expectAsync((_) {
          expect(document.query('.ace_content'), isNotNull);
        })
      );
    });

    test("defaults to disable edit-only mode", () {
      var it = new Editor(el);
      expect(it.edit_only, equals(false));
      expect(it.editorReady, completes);
    });

  });

  group("content", () {
    var el;
    setUp(() {
      el = new DivElement();
      document.body.append(el);
    });
    tearDown(()=> el.remove());

    test("can set the content", () {
      var it = new Editor(el);

      it.content = 'asdf';

      it.editorReady.then(
        expectAsync((_) {
          expect(it.content, equals('asdf'));
        })
      );

    });
  });

  group("focus", (){
    var el, editor;

    setUp((){
      el = new DivElement();
      document.body.append(el);

      editor = new Editor(el)..content = '<h1>preview</h1>';

      var preview_ready = new Completer();
      editor.onPreviewChange.listen((e){
        if (preview_ready.isCompleted) return;
        preview_ready.complete();
      });
      return preview_ready.future;
    });

    tearDown(()=> el.remove());

    test('code is visibile by default', (){
      var _el = el.query('.ice-code-editor-editor');

      expect(_el.style.visibility, isNot('hidden'));
    });

    test('focus goes to code if code is visibile', (){
      var _el = el.
        query('.ice-code-editor-editor').
        query('textarea.ace_text-input');

      expect(document.activeElement, _el);
    });

    test('focus goes to preview if code is hidden', (){
      editor.hideCode();

      var _el = el.query('iframe');

      expect(document.activeElement, _el);
    });

    group("hide code after an update", (){
      setUp((){
        editor.focus();
        editor.content = '<h1>Force Update</h1>';
        editor.hideCode();

        var preview_ready = new Completer();
        editor.onPreviewChange.listen((e){
          preview_ready.complete();
        });
        return preview_ready.future;
      });

      test('focus goes to preview if code is hidden', (){
        var _el = el.query('iframe');

        expect(document.activeElement, _el);
      });
    });
    // focus goes to preview if code is hidden
    // focus goes to preview after update if code is hidden
  });

  group("line number", (){
    var el, editor;

    setUp((){
      el = new DivElement();
      document.body.append(el);

      editor = new Editor(el)
        ..content = '''
Code line 01
Code line 02
Code line 03
Code line 04
Code line 05
Code line 06
Code line 07''';

      var preview_ready = new Completer();
      editor.onPreviewChange.listen((e){
        if (preview_ready.isCompleted) return;
        preview_ready.complete();
      });
      return preview_ready.future;
    });

    tearDown(()=> el.remove());

    test("defaults to 1", (){
      expect(editor.lineNumber, 1);
    });

    test("can be changed", (){
      editor.lineNumber = 6;
      expect(editor.lineNumber, 6);
    });

    test("can read current content", (){
      editor.lineNumber = 6;
      expect(editor.lineContent, 'Code line 06');
    });
  });
}
