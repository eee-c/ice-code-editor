part of ice;

class Full {
  Element el;
  Editor _ice;
  Store _store;

  Full({enable_javascript_mode: true}) {
    el = new Element.html('<div id=ice>');
    document.body.nodes.add(el);

    _ice = new Editor('#ice', enable_javascript_mode: enable_javascript_mode);
    _store = new Store();

    _attachToolbar();
    _attachKeyboardHandlers();
    _attachMouseHandlers();

    _fullScreenStyles();

    editorReady.then((_)=> _applyStyles());
    editorReady.then((_)=> content = _store.isEmpty ?
      '' : _store.projects.first['code']);
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

    _attachMainMenuButton(toolbar);

    el.children.add(toolbar);
  }

  _attachMainMenuButton(parent) {
    var el = new Element.html('<button>☰</button>');
    parent.children.add(el);

    el.onClick.listen((e)=> this.toggleMainMenu());
  }

  _attachKeyboardHandlers() {
    document.onKeyUp.listen((e) {
      if (!_isEscapeKey(e)) return;
      _hideMenu();
      _hideDialog();
    });
  }

  _attachMouseHandlers() {
    editorReady.then((_){
      el.query('.ice-code-editor-editor').
        onClick.
        listen((e){
          _hideMenu();
          _hideDialog();
        });
    });
  }

  _isEscapeKey(e) =>
    e.keyCode == 27 || e.$dom_keyIdentifier.codeUnits.first == 27;

  toggleMainMenu() {
    if (queryAll('.ice-menu,.ice-dialog').isEmpty) _showMainMenu();
    else {_hideMenu(); _hideDialog();}
  }

  _showMainMenu() {
    var menu = new Element.html('<ul class=ice-menu>');
    el.children.add(menu);

    menu.children
      ..add(_projectsMenuItem)
      ..add(_newProjectMenuItem)
      ..add(_renameMenuItem)
      ..add(_makeCopyItem)
      ..add(_saveMenuItem)
      ..add(_shareMenuItem)
      ..add(new Element.html('<li>Download</li>'))
      ..add(new Element.html('<li>Help</li>'));
  }

  _hideMenu() {
    queryAll('.ice-menu').forEach((e)=> e.remove());
  }

  _hideDialog() {
    queryAll('.ice-dialog').forEach((e)=> e.remove());
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
    dialog.query('input').focus();
  }

  _saveNewProject() {
    var title = query('.ice-dialog').query('input').value;
    if(_store.containsKey(title)) {
      var message = "There is already a project with that name";
      var alert = new Element.html('<div id="alert">$message</div>');

      el.children.add(alert..style.visibility="hidden");
      if(_ice.enable_javascript_mode) window.alert(message);
    }
    else {
      _store[title] = {};
      query('.ice-dialog').remove();
    }
  }

  Element get _projectsMenuItem {
    return new Element.html('<li>Projects</li>')
      ..onClick.listen((e)=> _hideMenu())
      ..onClick.listen((e)=> _openProjectsMenu());
  }

  _openProjectsMenu() {
    var menu = new Element.html(
      '''
      <div class=ice-menu>
      <h1>Saved Projects</h1>
      <ul></ul>
      </div>
      '''
    );

    _store.forEach((title, data) {
      var project = new Element.html('<li>${title}</li>')
        ..onClick.listen((e)=> _openProject(title))
        ..onClick.listen((e)=> _hideMenu());

      menu.query('ul').children.add(project);
    });

    el.children.add(menu);

    menu.style
      ..maxHeight = '560px'
      ..overflowY = 'auto'
      ..position = 'absolute'
      ..right = '25px'
      ..top = '60px'
      ..zIndex = '1000';
  }

  _openProject(title) {
    // TODO: Move this into Store (should be a way to make a project as
    // current)
    var project = _store.remove(title);
    _store[title] = project;
    _ice.content = project['code'];
  }

  Element get _renameMenuItem {
    return new Element.html('<li>Rename</li>')
      ..onClick.listen((e)=> _hideMenu())
      ..onClick.listen((e)=> _openRenameDialog());
  }

  _openRenameDialog(){
    var dialog = new Element.html(
        '''
        <div class=ice-dialog>
        <label>Name:<input type="text" size="30" value="$_currentProjectName"></label>
        <button>Rename</button>
        </div>
        '''
    );

    dialog.query('button').onClick
      ..listen((_)=> _renameProjectAs(dialog.query('input').value))
      ..listen((_)=> _hideDialog());

    el.children.add(dialog);

    dialog.query('input').focus();
    
  }

  _renameProjectAs(String projectName){
    var project = _store.remove(_currentProjectName);
    _store[projectName] = project;
  }

  String get _currentProjectName{
    if (_store.isEmpty) return "Untitled";
    return _store.projects.first['title'];    
  }
  

  Element get _makeCopyItem {
    return new Element.html('<li>Make a Copy</li>')
      ..onClick.listen((e)=> _hideMenu())
      ..onClick.listen((e)=> _openCopyDialog());
  }

  _openCopyDialog() {
    var dialog = new Element.html(
        '''
        <div class=ice-dialog>
        <label>Name:<input type="text" size="30" value="$_copiedProjectName"></label>
        <button>Save</button>
        </div>
        '''
    );

    dialog.query('button').onClick.listen((_)=> _copyProject());

    el.children.add(dialog);

    dialog.query('input').focus();
  }

  get _copiedProjectName {
    if (_store.isEmpty) return "Untitled";

    RegExp exp = new RegExp(r"\s+\((\d+)\)$");
    var title = _store.projects.first['title'].replaceFirst(exp, "");

    var same_base = _store.values.where((p) {
      return new RegExp("^" + title + r"(?:\s+\(\d+\))?$").hasMatch(p['title']);
    });
    var copy_numbers = same_base.map((p) {
        var stringCount = exp.firstMatch(p['title']);
        return stringCount == null ? 0 : int.parse(stringCount[1]);
      })
      .toList()
      ..sort();

    var count = copy_numbers.last;

    return "$title (${count+1})";
  }

  _copyProject() {
    var title = query('.ice-dialog').query('input').value;

    _store[title] = {'code': content};

    query('.ice-dialog').remove();
  }

  Element get _saveMenuItem {
    return new Element.html('<li>Save</li>')
      ..onClick.listen((e)=> _hideMenu())
      ..onClick.listen((e)=> _save());
  }

  void _save() {
    var title = _store.isEmpty ? 'Untitled' : _store.projects.first['title'];

    _store[title] = {'code': content};
  }

  Element get _shareMenuItem {
    return new Element.html('<li>Share</li>')
      ..onClick.listen((e)=> _hideMenu())
      ..onClick.listen((e)=> _openShareDialog());
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

    dialog.query('input')
      ..focus()
      ..select()
      ..disabled = true
      ..style.width = '100%';
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
