part of ice;

class MenuItem {
  MenuAction action;
  MenuItem(this.action);
  Element get el {
    return new Element.html('<li>${action.name}</li>')
      ..onClick.listen((e)=> _hideMenu())
      ..onClick.listen((e)=> action.open());
  }
}
