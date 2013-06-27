part of ice;

class OpenDialog extends Dialog implements MenuAction {
  OpenDialog(Full f): super(f);

  get name => "Open";

  open() {
    var menu = new Element.html(
      '''
      <div class=ice-menu>
      <h1>Saved Projects</h1>
      ${filterField}
      <ul></ul>
      </div>
      '''
    );

    parent.children.add(menu);
    addProjectsToMenu();

    menu.queryAll('input').forEach(_initializeFilter);

    menu.style
      ..maxHeight = '560px'
      ..overflowY = 'auto';
  }

  get filterField {
    if (store.length < 10) return '';
    return '<input type="text" placeholder="Filter projects">';
  }

  addProjectsToMenu({filter:''}) {
    var menu = query('.ice-menu');

    var projects = store.keys.
      where((title) {
        return title.toLowerCase().contains(filter.toLowerCase());
      }).
      map((title) {
        return new Element.html('<li>${title}</li>')
          ..onClick.listen((e)=> _openProject(title))
          ..onClick.listen((e)=> _hideMenu());
      }).
      toList();

    if (projects.length == 0) {
      projects = [new Element.html('<li class=empty>No matching projects.</li>')];
    }

    menu.query('ul').children.addAll(projects);
  }

  _openProject(title) {
    // TODO: Move this into Store (should be a way to make a project as
    // current)
    var project = store.remove(title);
    store[title] = project;
    ice.content = project['code'];
  }

  _initializeFilter(el) {
    el.focus();
    el.onKeyUp.listen((e) {
      query('.ice-menu ul')
        ..children.clear();
      addProjectsToMenu(filter: el.value);
    });
  }
}
