library key_event_x;

import 'dart:html';
import 'dart:async';

class KeyboardEventStreamX extends KeyboardEventStream {
  static Stream<KeyEventX> onKeyPress(target) { throw UnimplementedError; }
  static Stream<KeyEventX> onKeyUp(target) { throw UnimplementedError; }

  static Stream<KeyEventX> onKeyDown(EventTarget target) {
    return Element.
      keyDownEvent.
      forTarget(target).
      map((e)=> new KeyEventX(e));
  }
}

class KeyEventX extends KeyEvent {
  KeyboardEvent _parent;

  KeyEventX(KeyboardEvent parent): super(parent) {
    _parent = parent;
  }

  // Avoid bug in KeyEvent
  // https://code.google.com/p/dart/issues/detail?id=11139
  String get $dom_keyIdentifier => _parent.$dom_keyIdentifier;
  String get keyIdentifier => _parent.$dom_keyIdentifier;

  bool isCtrl(String char) => ctrlKey && isKey(char);
  bool isKey(String char) => char == key;

  bool isCtrlShift(String char) {
    if (!shiftKey) return false;
    return isCtrl(char);
  }

  String get key {
    if (keyCode == null) return 'Unidentified';
    return new String.fromCharCode(keyCode);
  }

  int get keyCode {
    if (keyIdentifier != null) return int.parse(keyIdentifier.replaceFirst('U+', '0x'));
    if (_parent.keyCode != 0) return _parent.keyCode;
    return null;
  }

  // TODO: Delegate to _parent
  // For now, satisfy dartanalyzer that we are extending properly
  Point layer;
  int layerX;
  int layerY;
  List<Node> path;
  int $dom_layerX;
  int $dom_layerY;
  int $dom_pageX;
  int $dom_pageY;
  int pageX;
  int pageY;
}
