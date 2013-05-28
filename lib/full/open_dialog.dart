part of ice;

class OpenDialog {
  String name = "Open";
  var parent, ice, store;

  OpenDialog(Full full): this.fromParts(full.el, full.ice, full.store);
  OpenDialog.fromParts(this.parent, this.ice, this.store);

  open() {
    var menu = new Element.html(
      '''
      <div class=ice-menu>
      <h1>Saved Projects</h1>
      <ul></ul>
      </div>
      '''
    );

    store.forEach((title, data) {
      var project = new Element.html('<li>${title}</li>')
        ..onClick.listen((e)=> _openProject(title))
        ..onClick.listen((e)=> _hideMenu());

      menu.query('ul').children.add(project);
    });

    parent.children.add(menu);

    menu.style
      ..maxHeight = '560px'
      ..overflowY = 'auto';
  }

  _openProject(title) {
    // TODO: Move this into Store (should be a way to make a project as
    // current)
    var project = store.remove(title);
    store[title] = project;
    ice.content = project['code'];
  }
}
