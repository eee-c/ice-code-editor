library latency_test;

import 'package:unittest/unittest.dart';
import 'dart:html';
import 'dart:async';

import 'package:ice_code_editor/ice.dart';

main(){
  Editor.disableJavaScriptWorker = true;

  group("Opening Shared Link", (){
    var editor, store;

    setUp((){
      window.location.hash = 'B/88gvT6nUUXDKT1IEAA==';

      editor = new Full()
        ..store.storage_key = "ice-test-${currentTestCase.id}";

      store = editor.store
        ..clear()
        ..['Current Project'] = {'code': 'Test'};

      return editor.gzipReady.then((_)=> new Future.delayed(new Duration(milliseconds: 10)));
    });

    tearDown((){
      window.location.hash = '';
      editor.remove();
      editor.store..clear()..freeze();
    });

    test("shared content is opened in the editor", (){
      expect(editor.content, 'Howdy, Bob!');
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
