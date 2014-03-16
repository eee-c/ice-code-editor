part of ice;

class WhatsNewAction implements MenuAction {
  WhatsNewAction(_);

  get name => "What's New";

  open(){
    document.body.append(el);

    el
      ..click()
      ..remove();
  }

  AnchorElement _el;
  get el {
    if (_el != null) return _el;

    _el = new AnchorElement()
      ..target = '_blank'
      ..style.display = 'none'
      ..href = 'https://github.com/eee-c/ice-code-editor/wiki/What\'s-New';

    return _el;
  }
}
