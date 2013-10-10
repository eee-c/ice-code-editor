import 'package:polymer/polymer.dart';

import 'dart:html';
import 'package:ice_code_editor/ice.dart' as ICE;

@CustomTag('ice-code-editor')
class IceCodeEditorElement extends PolymerElement with ObservableMixin {
  @published String src;
  @published int line_number = 0;
  ICE.Editor editor;

  void created() {
    super.created();

    // src = host.attributes['src'];
    // line_number = int.parse(host.attributes['line-number']);

    var container = new DivElement()
      ..id = 'ice-${this.hashCode}'
      ..style.width = '600px'
      ..style.height = '400px';

    host.append(container);

    var preview_el = new DivElement();
    shadowRoot.append(preview_el);

    // var editor = new ICE.Editor('#${container.id}');
    editor = new ICE.Editor(container, preview_el: preview_el);

    loadContent();
  }

  void inserted() {
    super.inserted();
    editor.applyStyles();
  }

  void attributeChanged(String name, String oldValue) {
    super.attributeChanged(name, oldValue);
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

/*
int lineNumber(String num) {
  if (num == null) return 1;
  if (num.isEmpty) return 1;
  return int.parse(num);
}
*/
