part of ice;

class HelpAction implements MenuAction {
  HelpAction(_);

  get name => "Help";


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
