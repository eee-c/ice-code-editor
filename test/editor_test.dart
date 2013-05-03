import 'package:unittest/unittest.dart';
import 'package:ice_code_editor/editor.dart';
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
      var it = new Editor('ice');
      expect(it.autoupdate, equals(true));
    });

    test("defaults to disable edit-only mode", () {
      var it = new Editor('ice');
      expect(it.edit_only, equals(false));
    });

    test("starts an ACE instance", (){
      var it = new Editor('ice');
      expect(document.query('.ace_content'), isNotNull);
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
      var it = new Editor('ice');
      it.content = 'asdf';
      expect(it.content, equals('asdf'));
    });
  });
}
