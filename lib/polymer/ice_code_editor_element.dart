import 'package:polymer/polymer.dart';

import 'dart:html';
import 'dart:async';

import 'package:ice_code_editor/ice.dart' as ICE;

@CustomTag('ice-code-editor')
class IceCodeEditorElement extends PolymerElement {
  @published String src;
  @published int line_number = 0;
  ICE.Editor editor;

  IceCodeEditorElement.created(): super.created() {
    var container = new DivElement()
      ..id = 'ice-${this.hashCode}'
      ..style.width = '600px'
      ..style.height = '400px';

    append(container);

    var preview_el = new DivElement();
    shadowRoot.append(preview_el);

    editor = new ICE.Editor(container, preview_el: preview_el);

    loadContent();
  }

  void inserted() {
    super.inserted();
    editor.applyStyles();
  }

  void attributeChanged(String name, String oldValue, String newValue) {
    super.attributeChanged(name, oldValue, newValue);
    loadContent();
  }

  Future loadContent() {
    if (src == null) return;

    HttpRequest.getString(src).then((response) {
      editor.content = response;
      editor.editorReady.then((_)=> editor.lineNumber = line_number);
    });
  }
}
