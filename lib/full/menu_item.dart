part of ice;

class MenuItem {
  MenuAction action;
  bool isHighlighted;
  MenuItem(this.action, {this.isHighlighted: false});
  Element get el {
    var className = isHighlighted ? 'highlighted' : '';
    return new Element.html('<li class="${className}">${action.name}</li>')
      ..onClick.listen((e)=> _hideMenu(focus:false))
      ..onClick.listen((e)=> action.open())
      ..onClick.listen((e)=> _maybeFocus());
  }
}
