import 'package:ice_code_editor/ice.dart' as ICE;
import 'dart:js';
import 'dart:async';
import 'dart:html';

var ice;

setContent(String content) {
  ice.content = content;
}

setLineNumber(int num) {
  ice.lineNumber = num;
}

Future loadContent(String src, [int lineNumber=1]) {
  if (src == null) return;

  HttpRequest.getString(src).then((response) {
    ice.content = response;
    ice.editorReady.then((_)=> ice.lineNumber = lineNumber);
  });
}

main() {
  context['loadContent'] = loadContent;
  ice = new ICE.Editor('#ice');
}