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

    // This only works because we have <content> tag to append to
    append(container);

    var preview_el = new DivElement()
      ..style.top = '-450px';
    var wrapper = new DivElement()
      ..style.position = 'relative';
    wrapper.append(preview_el);

    shadowRoot.append(wrapper);

    editor = new ICE.Editor(container, preview_el: preview_el);

    loadContent();
  }

  void enteredView() {
    super.enteredView();
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
