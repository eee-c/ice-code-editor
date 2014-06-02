library ice_html5_test;

import 'package:unittest/unittest.dart';
import 'dart:html';
import 'dart:async';

import 'helpers.dart' as helpers;
import 'package:ice_code_editor/ice.dart';

main() {
  group("HTML5", (){
    group("Full Screen ICE", (){
      tearDown(()=> document.query('#ice').remove());

      test("the editor is full-screen", (){
        var it = new Full();

        _test(_) {
          var el = document.query('#ice');
          var editor_el = el.query('.ice-code-editor-editor');
          expect(editor_el.clientWidth, window.innerWidth);
          expect(editor_el.clientHeight, closeTo(window.innerHeight,1.0));
          expect(document.body.clientHeight, greaterThan(10));
        };
        it.editorReady.then(expectAsync(_test));
      });
    });
  });

  pollForDone(testCases);
}

pollForDone(List tests) {
  if (tests.every((t)=> t.isComplete)) {
    window.postMessage('done', window.location.href);
    return;
  }

  var wait = new Duration(milliseconds: 100);
  new Timer(wait, ()=> pollForDone(tests));
}
