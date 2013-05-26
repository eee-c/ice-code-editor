part of ice;

class SaveMenu {
  Store store;
  Editor ice;

  SaveMenu(Full full) {
    store = full.store;
    ice = full.ice;
  }

  Element get el {
    return new Element.html('<li>Save</li>')
      ..onClick.listen((e)=> _hideMenu())
      ..onClick.listen((e)=> _save());
  }

  void _save() {
    var title = store.isEmpty ? 'Untitled' : store.projects.first['title'];

    store[title] = {'code': ice.content};
  }


}
