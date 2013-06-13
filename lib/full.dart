part of ice;

class Full {
  Element el;
  Editor ice;
  Store store;

  Full({enable_javascript_mode: true}) {
    el = new Element.html('<div id=ice>');
    document.body.nodes.add(el);

    ice = new Editor('#ice', enable_javascript_mode: enable_javascript_mode);
    store = new Store();

    _attachToolbar();
    _attachKeyboardHandlers();
    _attachMouseHandlers();

    _fullScreenStyles();

    editorReady
      ..then((_)=> _startAutoSave())
      ..then((_)=> _openProject())
      ..then((_)=> _applyEditorModes())
      ..then((_)=> _applyStyles());
  }

  Stream get onPreviewChange => ice.onPreviewChange;
  Future get editorReady => ice.editorReady;
  String get content => ice.content;
  void set content(data) => ice.content = data;

  _attachToolbar() {
    var toolbar = new Element.html('<div class=ice-toolbar>');
    toolbar.style
      ..position = 'absolute'
      ..top = '10px'
      ..right = '20px'
      ..zIndex = '999';

    toolbar.children
      ..add(_updateButton)
      ..add(_hideCodeButton)
      ..add(_showCodeButton)
      ..add(_mainMenuButton);

    el.children.add(toolbar);
  }

  Element _update_button;
  get _updateButton {
    return _update_button = new Element.html('''
        <button>
           <input checked type="checkbox" style="margin: -4px 4px -4px 0px;"/> Update
         </button>'''
      )
      ..query("input").onChange.listen((e)=> _toggleAutoupdate(e.target))
      ..query("input").onClick.listen((e)=> e.stopPropagation())
      ..onClick.listen((e)=> ice.updatePreview());
  }

  Element _hide_code_button;
  get _hideCodeButton {
    return _hide_code_button = new Element.html('<button>Hide Code</button>')
      ..onClick.listen((e)=> ice.hideCode())
      ..onClick.listen((e)=> e.target.style.display = 'none')
      ..onClick.listen((e)=> _main_menu_button.style.display = 'none')
      ..onClick.listen((e)=> _update_button.style.display = 'none')
      ..onClick.listen((e)=> _show_code_button.style.display = '');
  }

  Element _show_code_button;
  get _showCodeButton {
    return _show_code_button = new Element.html('<button>Show Code</button>')
      ..style.display = 'none'
      ..onClick.listen((e)=> ice.showCode())
      ..onClick.listen((e)=> e.target.style.display = 'none')
      ..onClick.listen((e)=> _main_menu_button.style.display = '')
      ..onClick.listen((e)=> _update_button.style.display = '')
      ..onClick.listen((e)=> _hide_code_button.style.display = '');
  }

  Element _main_menu_button;
  get _mainMenuButton {
    return _main_menu_button = new Element.html('<button>☰</button>')
      ..onClick.listen((e)=> this.toggleMainMenu());
  }
  _toggleAutoupdate(CheckboxInputElement e){
    ice.autoupdate = e.checked;
  }

  toggleMainMenu() {
    if (queryAll('.ice-menu,.ice-dialog').isEmpty) _showMainMenu();
    else {_hideMenu(); _hideDialog();}
  }

  _showMainMenu() {
    var menu = new Element.html('<ul class=ice-menu>');
    el.children.add(menu);

    menu.children
      ..add(_newProjectDialog)
      ..add(_openDialog)
      ..add(_copyDialog)
      ..add(_renameDialog)
      ..add(_saveMenu)
      ..add(_shareDialog)
      ..add(_downloadDialog)
      ..add(_removeDialog)
      ..add(_helpDialog);
  }

  get _openDialog=>       new MenuItem(new OpenDialog(this)).el;
  get _newProjectDialog=> new MenuItem(new NewProjectDialog(this)).el;
  get _renameDialog=>     new MenuItem(new RenameDialog(this)).el;
  get _copyDialog=>       new MenuItem(new CopyDialog(this)).el;
  get _saveMenu=>         new MenuItem(new SaveMenu(this)).el;
  get _shareDialog=>      new MenuItem(new ShareDialog(this)).el;
  get _removeDialog=>     new MenuItem(new RemoveDialog(this)).el;
  get _downloadDialog=> new DownloadDialog(this).el;
  get _helpDialog=>     new HelpDialog(this).el;

  String get encodedContent => Gzip.encode(ice.content);

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

  _fullScreenStyles() {
    document.body.style
      ..margin = '0px'
      ..overflow = 'hidden';
  }

  _openProject() {
    if (window.location.hash.startsWith('#B/')) {
      var title = store.nextProjectNamed('Untitled');
      content = Gzip.decode(window.location.hash.substring(3));
      store[title] = {'code': content};
      window.location.hash = '';
      return;
    }

    content = store.isEmpty ?
          DefaultProject.content : store.projects.first['code'];
  }

  _startAutoSave() {
    ice.onChange.listen((_){
      var title = store.isEmpty ? 'Untitled' : store.currentProjectTitle;

      store[title] = {'code': ice.content};
    });
  }

  _applyEditorModes() {
    // Users should use query params. Checking hash because it plays better
    // with tests. Query params cause a browser reload (bad in unit tests).
    if (window.location.search.contains('?e')) ice.edit_only = true;
    if (window.location.hash.startsWith('#e')) ice.edit_only = true;

    if (window.location.search.contains('?g')) ice.hideCode();
    if (window.location.hash.startsWith('#g')) ice.hideCode();
  }

  _applyStyles() {
     var editor_el = el.query('.ice-code-editor-editor');

     // Both of these height settings are required for ICE to play nicely
     // with HTML5 documents
     document.documentElement.style.height = '100%';
     document.body.style.height = '100%';

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

_hideMenu() {
  queryAll('.ice-menu').forEach((e)=> e.remove());
}

_hideDialog() {
  queryAll('.ice-dialog').forEach((e)=> e.remove());
}

class HelpDialog {
  HelpDialog(Full full);
  Element get el {
    return new Element.html('''
      <a
         target="_blank"
         href="https://github.com/eee-c/ice-code-editor/wiki"
         >
      <li>Help</li>
      </a>''');
  }
}

_isEscapeKey(e) =>
  e.keyCode == 27 || e.$dom_keyIdentifier.codeUnits.first == 27;

_isEnterKey(e) =>
  e.keyCode == 13 || e.$dom_keyIdentifier.codeUnits.first == 13;
