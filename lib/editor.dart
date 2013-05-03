library ice;

import 'dart:html';
import 'package:js/js.dart' as js;

class Editor {
  bool edit_only, autoupdate;
  String title;
  var _ace;

  Editor(el, {this.edit_only:false, this.autoupdate:true, this.title}) {
    _ace = js.context.ace.edit(el);
  }

  set content(String data) {
    _ace.setValue(data, -1);
  }

  String get content => _ace.getValue();
}
