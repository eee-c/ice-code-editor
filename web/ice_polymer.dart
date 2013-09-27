import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:ice_code_editor/ice.dart' as ICE;

@CustomTag('ice-code-editor')
class IceCodeEditorElement extends PolymerElement with ObservableMixin {
  @observable String src = '';
  @observable int lineNumber = 0;

  void created() {
    super.created();

    src = host.attributes['src'];
    lineNumber = int.parse(host.attributes['line-number']);

    var container = new DivElement()
      ..id = 'ice-${this.hashCode}'
      ..style.width = '600px'
      ..style.height = '400px';

    host.children.add(container);

    var editor = new ICE.Editor('#${container.id}');

    HttpRequest.getString(src).then((response) {
      editor.content = response;
      editor.editorReady.then((_)=> editor.lineNumber = lineNumber);
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
