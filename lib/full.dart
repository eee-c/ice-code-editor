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
      ..then((_)=> _applyStyles())
      ..then((_)=> content = store.isEmpty ?
          '' : store.projects.first['code']);
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
      ..add(_mainMenuButton);

    el.children.add(toolbar);
  }

  get _updateButton {
    return new Element.html('''
        <button>
           <input type="checkbox" style="margin: -4px 4px -4px 0px;"/> Update
         </button>'''
      )
      ..onClick.listen((e)=> ice.updatePreview());
  }

  get _hideCodeButton {
    return new Element.html('<button>Hide Code</button>');
  }

  get _mainMenuButton {
    return new Element.html('<button>☰</button>')
      ..onClick.listen((e)=> this.toggleMainMenu());
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

  _startAutoSave() {
    ice.onChange.listen((_){
      var title = store.isEmpty ? 'Untitled' : store.currentProjectTitle;

      store[title] = {'code': ice.content};
    });
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

_hideMenu() {
  queryAll('.ice-menu').forEach((e)=> e.remove());
}

_hideDialog() {
  queryAll('.ice-dialog').forEach((e)=> e.remove());
}

class DownloadDialog {
  DownloadDialog(Full full);
  Element get el {
    return new Element.html('<li>Download</li>');
  }
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
