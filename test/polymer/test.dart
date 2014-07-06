library ice_polymer_test;

import 'package:scheduled_test/scheduled_test.dart';
import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:ice_code_editor/ice.dart';

//
class PageComponent {
  final PolymerElement el;

  PageComponent(this.el);

  Future flush() {
    Completer completer = new Completer();
    el.async((_) => completer.complete());

    return completer.future;
  }
}

@initMethod
main() {
  var component1;
  var component2;
  //initPolymer();

  setUp((){
    //@TODO: check to see if async is returning or not
    schedule(() => Polymer.onReady );
    print("Entered Setup");

    schedule(() {
      print("Setup schedule");
      var elements = queryAll('ice-code-editor');

      component1 = new PageComponent(elements[0]);
      component2 = new PageComponent(elements[1]);

      //@TODO: investigate better async delay support for init of polymer element before test

      return Future.wait([component1.flush(), component2.flush()]);
    });
  });

  group("[polymer]", (){
    solo_test("can embed code", (){
      print("Entered test");
      schedule(() {
        print("in test schedule");
        expect(
          query('ice-code-editor').shadowRoot.query('h1').text,
          contains('embed_foo.html')
        );
      });
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
