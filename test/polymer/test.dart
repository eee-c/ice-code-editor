library polymer_test;

import 'package:unittest/unittest.dart';
import 'dart:html';
import 'dart:async';

main() {
  setUp((){
    var ready = new Completer();
    new Timer(
      new Duration(milliseconds: 250),
      ready.complete
    );
    return ready.future;
  });

  group("[polymer]", (){
    test("can embed code", (){
      expect(
        query('ice-code-editor').shadowRoot.query('h1').text,
        contains('embed.html')
      );
    });
    test("can set line number", (){
      expect(
        query('ice-code-editor').shadowRoot.query('h1').text,
        contains('(42)')
      );
    });
    test("creates a shadow preview", (){
      expect(
        query('ice-code-editor').shadowRoot.query('.ice-code-editor-preview'),
        isNotNull
      );
    });
    test("creates an editor", (){
      expect(
        query('ice-code-editor').query('.ice-code-editor-editor'),
        isNotNull
      );
    });
  });

  pollForDone(testCases);
}

pollForDone(List tests) {
  if (tests.every((t)=> t.isComplete)) {
    window.postMessage('dart-main-done', '*');
    return;
  }

  new Timer(
    new Duration(milliseconds: 100),
    ()=> pollForDone(tests)
  );
}
