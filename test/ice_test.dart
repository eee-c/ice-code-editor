@TestOn('dartium')
library ice_test;

import 'package:test/test.dart';
import 'dart:html';
import 'dart:async';

import 'helpers.dart' as helpers;
import 'package:ice_code_editor/ice.dart';

part 'editor_test.dart';
part 'store_test.dart';
part 'settings_test.dart';
part 'gzip_test.dart';

part 'full_test.dart';
part 'full/update_button_test.dart';
part 'full/hide_button_test.dart';
part 'full/show_button_test.dart';
part 'full/notification_test.dart';
part 'full/new_project_dialog_test.dart';
part 'full/open_dialog_test.dart';
part 'full/copy_dialog_test.dart';
part 'full/rename_dialog_test.dart';
part 'full/save_dialog_test.dart';
part 'full/share_dialog_test.dart';
part 'full/download_test.dart';
part 'full/export_test.dart';
part 'full/import_test.dart';
part 'full/whats_new_test.dart';
part 'full/remove_dialog_test.dart';
part 'full/keyboard_shortcuts_test.dart';
part 'full/snapshotter_test.dart';

void main(){
  Editor.disableJavaScriptWorker = true;

  editor_tests();

  store_tests();
  settings_tests();
  gzip_tests();

  full_tests();

  update_button_tests();
  hide_button_tests();
  show_button_tests();
  notification_tests();
  new_project_dialog_tests();
  open_dialog_tests();

  // START HERE: the two commented our tests are locking, but only under
  // content-shell / dartium, not directly from dartium connecting to port
  // 8081. Very probably a bug in the test package. Maybe figure these out, but
  // start with fixing the remaing 7 failures and then moving the remaining
  // failures to a separate test file (maybe it would have to be manualy testing
  // only, ick).
  copy_dialog_tests();
  rename_dialog_tests();
  save_dialog_tests();
  // share_dialog_tests();
  download_tests();
  export_tests();
  import_tests();
  whats_new_tests();
  remove_dialog_tests();
  snapshotter_tests();

  // // Leave these tests last b/c they were failing at one point, but only when
  // // last (hoping to see this again).
  keyboard_shortcuts_tests();
}

get currentTestCase => new CurrentTestCase();

class CurrentTestCase {
  String id;
  CurrentTestCase(){
    id = new DateTime.now().millisecondsSinceEpoch.toString();
  }
}
