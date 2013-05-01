import 'package:js/js.dart' as js;

class ICE {
  ICE.Full(el) {
    var context = js.context;
    context.ace.edit(el);
  }
}
