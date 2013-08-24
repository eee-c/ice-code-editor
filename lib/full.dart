part of ice;

class Full {
  Element el;
  Editor ice;
  Store store;
  Map templates;

  Full({this.templates}) {
    el = new Element.html('<div id=ice>');
    document.body.nodes.add(el);

    ice = new Editor('#ice');
    store = new Store();

    _attachKeyboardHandlers();
    _attachMouseHandlers();
    _attachMessageHandlers();

    _fullScreenStyles();

    editorReady
      ..then((_)=> _attachCodeToolbar())
      ..then((_)=> _attachPreviewToolbar())
      ..then((_)=> _startAutoSave())
      ..then((_)=> _openProject())
      ..then((_)=> _applyEditorModes())
      ..then((_)=> _applyStyles());
  }

  Stream get onPreviewChange => ice.onPreviewChange;
  Future get editorReady => ice.editorReady;
  String get content => ice.content;
  void set content(data) => ice.content = data;

  String get lineContent => ice.lineContent;
  int get lineNumber => ice.lineNumber;
  set lineNumber(int v) { ice.lineNumber = v; }

  void remove() {
    Keys.cancel();
    el.remove();
  }

  _attachCodeToolbar() {
    var toolbar = new Element.html('<div class=ice-toolbar>');
    toolbar.style
      ..position = 'absolute'
      ..top = '10px'
      ..right = '20px'
      ..zIndex = '89'; // below ACE's searchbox

    toolbar.children
      ..add(_updateButton)
      ..add(_hideCodeButton)
      ..add(_mainMenuButton);

    editor_el.children.add(toolbar);
  }

  _attachPreviewToolbar() {
    var toolbar = new Element.html('<div class=ice-toolbar>');
    toolbar.style
      ..position = 'absolute'
      ..top = '10px'
      ..right = '20px'
      ..zIndex = '999';

    toolbar.children
      ..add(_showCodeButton);

    el.children.add(toolbar);
  }

  Element _update_button;
  get _updateButton {
    return _update_button = new Element.html('''
        <button>
           <input
              checked
              type=checkbox
              title="$_update_tooltip"
              style="margin: -10px 4px;"/>
           Update
         </button>'''
      )
      ..onClick.listen((e)=> ice.updatePreview())
      ..query("input").onClick.listen((e)=> e.stopPropagation())
      ..query("input").onChange.listen((e)=> _toggleAutoupdate(e.target))
      ..query("input").onChange.
          where((e) => e.target.checked).
          listen((e)=> ice.updatePreview());
  }

  get _update_tooltip => '''
If not checked, then the preview is not auto-updated. The
only way to see changes is to click the button.

If checked, the preview is updated whenever the code is
changed.''';

  toggleCode() {
    if (ice.isCodeVisible) {
      hideCode();
    }
    else {
      showCode();
    }
  }

  Element _hide_code_button;
  get _hideCodeButton {
    return _hide_code_button = new Element.html('<button>Hide Code</button>')
      ..onClick.listen((e)=> hideCode());
  }

  void hideCode() {
    ice.hideCode();
    _hide_code_button.style.display = 'none';
    _main_menu_button.style.display = 'none';
    _update_button.style.display = 'none';
    _show_code_button.style.display = '';
    _focusAfterPreviewChange();
  }

  _focusAfterPreviewChange() {
    var listener;

    listener = ice.onPreviewChange.listen((e) {
      ice.focus();
      listener.cancel();
    });
    new Timer(new Duration(milliseconds: 2500), (){
      listener.cancel();
    });
  }

  Element _show_code_button;
  get _showCodeButton {
    return _show_code_button = new Element.html('<button>Show Code</button>')
      ..style.display = 'none'
      ..onClick.listen((e)=> showCode());
  }

  void showCode() {
    ice.showCode();
    _show_code_button.style.display = 'none';
    _main_menu_button.style.display = '';
    _update_button.style.display = '';
    _hide_code_button.style.display = '';
  }

  Element _main_menu_button;
  get _mainMenuButton {
    return _main_menu_button = new Element.html('<button>☰</button>')
      ..onClick.listen((e) {
        this.toggleMainMenu();
        e.stopPropagation();
      });
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
      ..add(_saveDialog)
      ..add(_shareDialog)
      ..add(_downloadDialog)
      ..add(_removeDialog)
      ..add(_helpDialog);
  }

  get _openDialog=>       new MenuItem(new OpenDialog(this)).el;
  get _newProjectDialog=> new MenuItem(new NewProjectDialog(this)).el;
  get _renameDialog=>     new MenuItem(new RenameDialog(this)).el;
  get _copyDialog=>       new MenuItem(new CopyDialog(this)).el;
  get _saveDialog=>       new MenuItem(new SaveAction(this)).el;
  get _shareDialog=>      new MenuItem(new ShareDialog(this)).el;
  get _removeDialog=>     new MenuItem(new RemoveDialog(this)).el;
  get _downloadDialog=>   new MenuItem(new DownloadDialog(this)).el;
  get _helpDialog=>       new MenuItem(new HelpAction(this)).el;

  String get encodedContent => Gzip.encode(ice.content);

  _attachKeyboardHandlers() {
    Keys.shortcuts({
      'Ctrl+N, Ctrl+O, ⌘+O, Ctrl+Shift+H': _hideDialog
    });
    Keys.shortcuts({
      'Esc':          ()=> _hideDialog(),
      'Ctrl+N':       ()=> new NewProjectDialog(this).open(),
      'Ctrl+O, ⌘+O':  ()=> new OpenDialog(this).open(),
      'Ctrl+Shift+H': ()=> toggleCode()
    });

    editorReady.then((_){
      el.onFocus.listen((e)=> ice.focus());
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

  _attachMessageHandlers() {
    window.onMessage.listen((e) {
      showCode();
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

      store[title] = {
        'code': ice.content,
        'lineNumber': ice.lineNumber
      };
    });
  }

  _applyEditorModes() {
    // Users should use query params. Checking hash because it plays better
    // with tests. Query params cause a browser reload (bad in unit tests).
    if (window.location.search.contains('?e')) ice.edit_only = true;
    if (window.location.hash.startsWith('#e')) ice.edit_only = true;

    if (window.location.search.contains('?g')) hideCode();
    if (window.location.hash.startsWith('#g')) hideCode();
  }

  Element get editor_el => ice.editor_el;
  Element get preview_el => ice.preview_el;

  _applyStyles() {
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

_hideMenu({focus:true}) => _hideDialog(focus:focus);

_hideDialog({focus:true}) {
  queryAll('.ice-menu').forEach((e)=> e.remove());
  queryAll('.ice-dialog').forEach((e)=> e.remove());
  if (focus) _maybeFocus();
}

_maybeFocus() {
  if (document.activeElement.tagName == 'INPUT') return;
  query('#ice').dispatchEvent(new UIEvent('focus'));
}
