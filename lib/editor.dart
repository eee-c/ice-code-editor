import 'package:js/js.dart' as js;

class Editor {
  Editor(el) {
    var context = js.context;
    context.ace.edit(el);
  }
}
