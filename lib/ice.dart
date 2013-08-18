library ice;

import 'dart:async';
import 'dart:collection';
import 'dart:html';
import 'dart:json' as JSON;
import 'package:js/js.dart' as js;
import 'package:js/js_wrapping.dart' as jsw;
import 'package:crypto/crypto.dart';

import 'package:ctrl_alt_foo/keys.dart';

part 'editor.dart';
part 'store.dart';
part 'gzip.dart';

part 'full.dart';
part 'full/default_project.dart';
part 'full/templates.dart';
part 'full/notify.dart';
part 'full/validate.dart';

part 'full/menu_item.dart';
part 'full/menu_action.dart';
part 'full/dialog.dart';

part 'full/open_dialog.dart';
part 'full/new_project_dialog.dart';
part 'full/rename_dialog.dart';
part 'full/save_action.dart';
part 'full/share_dialog.dart';
part 'full/download_dialog.dart';
part 'full/copy_dialog.dart';
part 'full/remove_dialog.dart';
part 'full/help_action.dart';
