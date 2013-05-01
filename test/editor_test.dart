import 'package:unittest/unittest.dart';
import 'package:ice_code_editor/editor.dart';
import 'dart:html';

main() {
  group("defaults", () {
    test("defaults to auto-update the preview", () {
      var it = new Editor('ice');
      expect(it.autoupdate, equals(true));
    });

    test("defaults to disable edit-only mode", () {
      var it = new Editor('ice');
      expect(it.edit_only, equals(false));
    });
  });
}
