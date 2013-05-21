library ice_test;

import 'package:unittest/unittest.dart';
import 'dart:html';
import 'dart:async';

import 'helpers.dart' as helpers;
import 'package:ice_code_editor/ice.dart';

part 'editor_test.dart';
part 'store_test.dart';
part 'gzip_test.dart';
part 'full_test.dart';


main(){
  editor_tests();
  store_tests();
  gzip_tests();
  full_tests();
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
