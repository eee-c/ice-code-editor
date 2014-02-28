part of ice;

class WhatsNewAction implements MenuAction {
  WhatsNewAction(_);

  get name => "What's New";

  open(){
    AnchorElement el = new Element.html('<a target="_blank"></a>');

    el
      ..style.display = 'none'
      ..href = 'https://github.com/eee-c/ice-code-editor/wiki';

    document.body.append(el);

    el
      ..click()
      ..remove();
  }
}
