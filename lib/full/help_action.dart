part of ice;

class HelpAction implements MenuAction {
  HelpAction(_);

  get name => "Help";

  open(){
    new Element.html('''
      <a
         target="_blank"
         href="https://github.com/eee-c/ice-code-editor/wiki">'''
    )
      ..click();
  }
}
