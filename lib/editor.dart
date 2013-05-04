library ice;

import 'dart:html';
import 'dart:async';
import 'package:js/js.dart' as js;

class Editor {
  bool edit_only, autoupdate;
  String title;
  var _ace;
  Completer _waitForAce;

  Editor(id, {this.edit_only:false, this.autoupdate:true, this.title}) {
    var script = new ScriptElement();
    script.src = "packages/ice_code_editor/ace/ace.js";
    document.head.nodes.add(script);

    this._waitForAce = new Completer();

    script.onLoad.listen((event) {
      this._ace = js.context.ace.edit(id);
      js.retain(this._ace);
      this._waitForAce.complete();
    });
  }

  set content(String data) {
    if (!_waitForAce.isCompleted) {
      editorReady.then((_) => this.content = data);
      return;
    }

    this._ace.setValue(data, -1);
    this._ace.focus();
  }

  String get content => _ace.getValue();
  Future get editorReady => _waitForAce.future;
}
