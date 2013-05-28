part of ice;

class MenuItem {
  var dialog;
  MenuItem(this.dialog);
  Element get el {
    return new Element.html('<li>${dialog.name}</li>')
      ..onClick.listen((e)=> _hideMenu())
      ..onClick.listen((e)=> dialog.open());
  }
}
