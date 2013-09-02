import 'dart:html';
import 'package:ice_code_editor/ice.dart' as ICE;

main() {
  queryAll('script[type="text/ice-code"]').
    forEach((script_el) {

      var container = new DivElement()
        ..id = 'ice-01'
        ..style.width = '600px'
        ..style.height = '400px';

      script_el.
        insertAdjacentElement('afterEnd', container);

      var editor = new ICE.Editor('#${container.id}');

      HttpRequest.getString(script_el.src).then((response) {
        editor.content = response;
        editor.lineNumber = lineNumber(
          script_el.attributes['data-line-number']
        );
      });
    });
}

int lineNumber(String num) {
  if (num == null) return 1;
  if (num.isEmpty) return 1;
  return int.parse(num);
}
