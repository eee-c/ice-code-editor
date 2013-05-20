part of ice;

class Full {
  Element el;
  Editor _ice;
  Store _store;

  Full({enable_javascript_mode: true}) {
    el = new Element.html('<div id=ice>');
    document.body.nodes.add(el);

    _attachToolbar();
    _fullScreenStyles();
    _ice = new Editor('#ice', enable_javascript_mode: enable_javascript_mode);
    _store = new Store();

    editorReady.then((_)=> _applyStyles());
    editorReady.then((_)=> content = _store.projects.first['code']);
  }

  Future get editorReady => _ice.editorReady;
  String get content => _ice.content;
  void set content(data) => _ice.content = data;

  _attachToolbar() {
    var toolbar = new Element.html('<div class=ice-toolbar>');
    toolbar.style
      ..position = 'absolute'
      ..top = '10px'
      ..right = '20px'
      ..zIndex = '999';

    _attachMenuButton(toolbar);

    el.children.add(toolbar);
  }

  _attachMenuButton(parent) {
    var el = new Element.html('<button>☰</button>');
    parent.children.add(el);

    el.onClick.listen((e)=> this.toggleMenu());
  }

  toggleMenu() {
    if (queryAll('.ice-menu').isEmpty) _showMenu();
    else _hideMenu();
  }

  _showMenu() {
    var menu = new Element.html('<ul class=ice-menu>');
    el.children.add(menu);

    menu.style
      ..position = 'absolute'
      ..right = '17px'
      ..top = '55px'
      ..zIndex = '999';

    menu.children
      ..add(_newProjectMenuItem)
      ..add(_projectsMenuItem())
      ..add(_saveMenuItem)
      ..add(new Element.html('<li>Make a Copy</li>'))
      ..add(_shareMenuItem())
      ..add(new Element.html('<li>Download</li>'))
      ..add(new Element.html('<li>Help</li>'));
  }

  _hideMenu() {
    // TODO: This is necessary in tests because the project menu listener is
    // not being removed between tests
    if (query('.ice-menu') == null) return;
    query('.ice-menu').remove();
  }

  get _newProjectMenuItem {
    return new Element.html('<li>New</li>')
      ..onClick.listen((e)=> _openNewProjectDialog());
  }

  _openNewProjectDialog() {
    _hideMenu();

    var dialog = new Element.html(
        '''
        <div class=ice-dialog>
        <label>Name:<input type="text" size="30"></label>
        <button>Save</button>
        </div>
        '''
    );

    dialog.query('button').onClick.listen((e)=> _saveNewProject());

    el.children.add(dialog);
  }

  _saveNewProject() {
    var title = query('.ice-dialog').query('input').value;
    _store[title] = {};

    query('.ice-dialog').remove();
  }


  _projectsMenuItem() {
    document.onKeyUp.listen((e) {
      if (e.keyCode == 27) _hideMenu();
      if (e.$dom_keyIdentifier.codeUnits.first == 27) _hideMenu();
    });

    return new Element.html('<li>Projects</li>')
      ..onClick.listen((e)=> _openProjectsMenu())
      ..onClick.listen((e)=> _hideMenu());
  }

  _openProjectsMenu() {
    var menu = new Element.html(
        '''
        <div class=ice-menu>
        <h1>Saved Projects
        </div>
        '''
    );

    el.children.add(menu);

    menu.style
      ..maxHeight = '560px'
      ..overflowY = 'auto'
      ..position = 'absolute'
      ..right = '17px'
      ..top = '60px'
      ..zIndex = '1000';
  }

  Element get _saveMenuItem {
    return new Element.html('<li>Save</li>')
      ..onClick.listen((e)=> _save());
  }

  void _save() {
    var title = _store.isEmpty ? 'Untitled' : _store.projects.first['title'];

    _store[title] = {'code': content};
  }

  _shareMenuItem() {
    return new Element.html('<li>Share</li>')
      ..onClick.listen((e) => _openShareDialog());
  }

  _openShareDialog() {
    var dialog = new Element.html(
        '''
        <div class=ice-dialog>
        <h1>Copy this link to share your creation:</h1>
        <input
          value="http://gamingjs.com/ice/#B/${encodedContent}"
          style="width=400px; padding=5px; border=0px">
        </div>
        '''
    );

    el.children.add(dialog);

    dialog.style
      ..left = "${(window.innerWidth - dialog.offsetWidth)/2}px"
      ..top = "${(window.innerHeight - dialog.offsetHeight)/2}px";
  }

  String get encodedContent => Gzip.encode(_ice.content);

  _fullScreenStyles() {
    document.body.style
      ..margin = '0px'
      ..overflow = 'hidden';
  }

  _applyStyles() {
     var editor_el = el.query('.ice-code-editor-editor');

     editor_el.style
       ..top = '0'
       ..bottom = '0'
       ..left = '0'
       ..right = '0'
       ..backgroundColor = 'rgba(255,255,255,0.0)';

     el.style
       ..height = '100%'
       ..width = '100%';
  }
}
