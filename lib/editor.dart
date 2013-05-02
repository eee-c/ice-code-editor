library ice;

import 'dart:html';
import 'package:js/js.dart' as js;

class Editor {
  bool edit_only, autoupdate;
  String title;

  Editor(el, {this.edit_only:false, this.autoupdate:true, this.title}) {
    var context = js.context;
    context.ace.edit(el);
  }
}
