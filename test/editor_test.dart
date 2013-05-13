import 'package:unittest/unittest.dart';
import 'package:ice_code_editor/ice.dart';
import 'dart:html';

main() {
  group("defaults", () {
    var el;
    setUp(() {
      el = new Element.html('<div id=ice>');
      document.body.nodes.add(el);
    });
    tearDown(()=> document.body.nodes.remove(el));

    test("defaults to auto-update the preview", () {
      var it = new Editor('#ice');
      expect(it.autoupdate, equals(true));
    });

    test("defaults to disable edit-only mode", () {
      var it = new Editor('#ice');
      expect(it.edit_only, equals(false));
      expect(it.editorReady, completes);
    });

    test("starts an ACE instance", (){
      var it = new Editor('#ice');
      it.editorReady.then(
        expectAsync1((_) {
          expect(document.query('.ace_content'), isNotNull);
        })
      );
    });
  });

  group("content", () {
    var el;
    setUp(() {
      el = new Element.html('<div id=ice>');
      document.body.nodes.add(el);
    });
    tearDown(()=> document.body.nodes.remove(el));

    test("can set the content", () {
      var it = new Editor('#ice');

      it.content = 'asdf';

      it.editorReady.then(
        expectAsync1((_) {
          expect(it.content, equals('asdf'));
        })
      );

    });
  });
}
