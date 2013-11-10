part of ice;

class OpenDialog extends Dialog implements MenuAction {
  OpenDialog(Full f): super(f);

  get name => "Open";

  Element menu;

  open() {
    menu = new Element.html(
      '''
      <div class=ice-menu>
      <h1>Saved Projects</h1>
      ${filterField}
      <ul></ul>
      <button id=fake_enter_key></button>
      <button id=fake_down_key></button>
      <button id=fake_up_key></button>
      </div>
      '''
    );

    menu.
      queryAll('button').
      forEach((b){ b.style.display = 'none';});

    parent.append(menu);
    addProjectsToMenu();

    menu.queryAll('input').forEach(_addListeners);
    _focus(menu);
    _handleArrowKeys(menu);

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

    var projects = store.projects.
      where((project) {
        return project['filename'].toLowerCase().contains(filter.toLowerCase());
      }).
      map((project) {
        var title = project["filename"],
          created_at = project["created_at"],
          updated_at = project["updated_at"];

        var tooltip = (created_at == null || updated_at == null) ? '' : '''
Created: ${created_at.substring(0,10)}
Last Updated: ${updated_at.substring(0,10)}''';

        return new Element.html('<li title="${tooltip}">${title}</li>')
          ..tabIndex = 0
          ..onClick.listen((e)=> _openProject(title))
          ..onClick.listen((e)=> _hideMenu())
          ..onKeyDown.listen((e) {
            if (!Keys.isEnter(e)) return;
            e.preventDefault();
            e.target.click();
          });
      }).
      toList();

    if (projects.length == 0) {
      projects = [new Element.html('<li class=empty>No matching projects.</li>')];
    }

    menu.query('ul').children.addAll(projects);
  }

  _openProject(title) {
    var old = store.currentProject,
        old_title = old['filename'];
    old['lineNumber'] = ice.lineNumber;
    store[old_title] = old;

    // TODO: Move this into Store (should be a way to make a project as
    // current)
    var project = store.remove(title);
    store[title] = project;
    ice.content = project['code'];
    if (project['lineNumber'] != null) {
      ice.lineNumber = project['lineNumber'];
    }
  }

  _addListeners(el) {
    _initializeFilter(el);
    _handleEnter(el);
  }

  _initializeFilter(el) {
    el.onKeyUp.listen((e) {
      query('.ice-menu ul')
        ..children.clear();
      addProjectsToMenu(filter: el.value);
    });
  }

  _handleEnter(el) {
    clickActive() {
      if (el.value.isEmpty) return;
      query('.ice-menu ul').children.first.click();
    }

    el.onKeyDown.listen((e){
      if (e.keyCode != KeyCode.ENTER) return;
      clickActive();
    });

    // Hack in lieu of KeyEvent tests
    menu.query('#fake_enter_key').onClick.listen((_)=> clickActive());
  }

  _focus(el) {
    if (el.query('input') == null) {
      el.query('li').focus();
    }
    else {
      el.query('input').focus();
    }
  }

  _handleArrowKeys(el) {
    el.onKeyDown.listen(_handleDown);
    el.onKeyDown.listen(_handleUp);

    // Hacks in lieu of KeyEvent tests
    menu.query('#fake_down_key').onClick.listen(_handleDown);
    menu.query('#fake_up_key').onClick.listen(_handleUp);
  }

  _handleDown(e) {
    if (e.type == 'keydown' && e.keyCode != KeyCode.DOWN) return;

    var next = document.activeElement.nextElementSibling;
    if (next == null) {
      next = document.activeElement;
    }
    if (next.tagName == 'UL') {
      next = next.children.first;
    }
    next.focus();
  }

  _handleUp(e) {
    if (e.type == 'keydown' && e.keyCode != KeyCode.UP) return;

    var prev = document.activeElement.previousElementSibling;
    if (prev == null) {
      prev = menu.query('input');
    }
    if (prev == null) {
      prev = document.activeElement;
    }
    prev.focus();
  }
}
