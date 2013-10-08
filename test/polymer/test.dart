library ice_polymer_test;

import 'package:scheduled_test/scheduled_test.dart';
import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:ice_code_editor/ice.dart';

main() {
  setUp((){
    var ready = new Completer();
    new Timer(
      new Duration(milliseconds: 5),
      ready.complete
    );
    return ready.future;
  });

  group("[polymer]", (){
    test("can embed code", (){
      expect(
        query('ice-code-editor').shadowRoot.query('h1').text,
        contains('embed_foo.html')
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

    group("multiple elements", (){
      test("can embed code", (){
        expect(
          queryAll('ice-code-editor').last.shadowRoot.query('h1').text,
          contains('embed_bar.html')
        );
      });

      test("can still embed code after JS is loaded and evaluated", (){
        schedule(()=> Editor.jsReady);

        schedule((){
          var later = createElement('ice-code-editor')
            ..xtag.src = 'embed_baz.html';

          document.body.append(later);

          return new Future.delayed(Duration.ZERO);
        });

        schedule((){
          expect(
            queryAll('ice-code-editor').last.shadowRoot.query('h1').text,
            contains('embed_baz.html')
          );
        });
      });


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
