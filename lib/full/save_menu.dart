part of ice;

class SaveMenu {
  String name = 'Save';
  var parent, ice, store;

  SaveMenu(Full full): this.fromParts(full.el, full.ice, full.store);
  SaveMenu.fromParts(this.parent, this.ice, this.store);

  void open() {
    var title = store.isEmpty ? 'Untitled' : store.projects.first['title'];

    store[title] = {'code': ice.content};
  }


}
