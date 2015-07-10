import 'dart:html';
import 'package:ice_code_editor/ice.dart' as ICE;

main() {
  new ICE.Full(
    mode: window.location.search,
    compressedContent: window.location.hash
  );

  window.location.hash = '';
}
