import 'package:unittest/unittest.dart';
import 'dart:html';
import 'package:ice_code_editor/ice.dart';

main() {
  group("initial UI", (){
    test("the editor is full-screen", (){
      var it = new Full();

      _test(_) {
        var el = document.query('#ice');
        var editor_el = el.query('.ice-code-editor-editor');
        expect(editor_el.clientWidth, window.innerWidth);
        expect(editor_el.clientHeight, closeTo(window.innerHeight,1.0));
      };
      it.editorReady.then(expectAsync1(_test));
    });
  });
}
