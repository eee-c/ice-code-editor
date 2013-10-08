import 'dart:html';
import 'package:polymer/polymer.dart';

main() {
  // This gets: Removing disallowed element <ICE-CODE-EDITOR> ...
  // var later = createElementFromHtml('<ice-code-editor src="embed_baz.html" line_number="0"></ice-code-editor>');

  // Don't see attributes change ...
  // var later = createElement('ice-code-editor')
  //   ..attributes['src'] = 'embed_baz.html'
  //   ..attributes['line_number'] = '0';

  var later = createElement('ice-code-editor');
  var iceElement = later.xtag;
  iceElement.src = 'embed_c.html';

  document.body.append(later);
}
