part of ice;

class Full {
  Element el;
  Editor ice;
  Store store;
  Snapshotter snapshotter;
  Settings settings;

  String mode;
  String compressedContent;

  Full({mode, this.compressedContent:''}) {
    el = new Element.html('<div id=ice>');
    document.body.nodes.add(el);

    ice = new Editor('#ice');
    store = new Store();
    settings = new Settings();
    this.mode = mode?.replaceFirst(new RegExp(r'^\?'), '');

    _attachKeyboardHandlers();
    _attachMouseHandlers();
    _attachMessageHandlers();
    _attachDropHandlers();

    _fullScreenStyles();

    editorReady
      ..then((_)=> _startSnapshotter())
      ..then((_)=> _attachCodeToolbar())
      ..then((_)=> _attachPreviewToolbar())
      ..then((_)=> _startAutoSave())
      ..then((_)=> _openProject())
      ..then((_)=> _initializeSettingForFirstUse())
      ..then((_)=> _initializeMode())
      ..then((_)=> _applyStyles());
  }

  Stream get onPreviewChange => ice.onPreviewChange;
  Future get editorReady => Future.wait([ice.editorReady, Gzip._ready]);
  String get content => ice.content;
  void set content(data) { ice.content = data; }

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
      ..add(_leaveSnapshotModeButton)
      ..add(_hideCodeButton)
      ..add(_mainMenuButton);

    editor_el.children.add(toolbar);

    if (!_isFirstUse) _drawWhatsNewIndicator(toolbar);
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

  void hideCode() {
    ice.hideCode();
    _showCodeButton.style.display = '';
    _hideCodeButton.style.display = 'none';
    _mainMenuButton.style.display = 'none';
    _updateButton.style.display = 'none';
    _leaveSnapshotModeButton.style.display = 'none';
    _focusAfterPreviewChange();
  }

  void showCode() {
    ice.showCode();
    _showCodeButton.style.display = 'none';
    _hideCodeButton.style.display = '';
    _mainMenuButton.style.display = '';
    _updateButton.style.display = '';
    _leaveSnapshotModeButton.style.display = '';
  }

  Element _show_code_button;
  get _showCodeButton {
    if (_show_code_button != null) return _show_code_button;

    return _show_code_button = new Element.html('<button>Show Code</button>')
      ..style.display = 'none'
      ..onClick.listen((e)=> showCode());
  }

  Element _hide_code_button;
  get _hideCodeButton {
    if (_hide_code_button != null) return _hide_code_button;

    return _hide_code_button = new Element.html('<button>Hide Code</button>')
      ..onClick.listen((e)=> hideCode());
  }

  Element _main_menu_button;
  get _mainMenuButton {
    if (_main_menu_button != null) return _main_menu_button;

    return _main_menu_button = new Element.html('<button>☰</button>')
      ..onClick.listen((e) {
        this.toggleMainMenu();
        e.stopPropagation();
      });
  }

  Element _update_button;
  get _updateButton {
    if (_update_button != null) return _update_button;
    if (store.show_snapshots) return _update_button = new Element.span();

    return _update_button = new Element.html('''
        <button>
           <input checked type=checkbox title="$_update_tooltip"/>
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

  Element _leave_snapshot_mode_button;
  get _leaveSnapshotModeButton {
    if (_leave_snapshot_mode_button != null) return _leave_snapshot_mode_button;
    if (!store.show_snapshots) return _leave_snapshot_mode_button = new Element.span();

    return _leave_snapshot_mode_button = new Element.html('''
        <button>Leave Snapshot Mode</button>'''
      )
      ..onClick.listen((e){
        window.location.search = '';
      })
      ..style.color = 'red'
      ..style.fontWeight = 'bold';
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

  _drawWhatsNewIndicator(toolbar) {
    if (_whatsNewClicked) return;

    var new_indicator = new Element.html('<span id=somethingsnew>★</span>');
    new_indicator.style
      ..color = 'red'
      ..fontSize = '36px'
      ..position = 'absolute'
      ..top = '-20px'
      ..right = '-7px'
      ..textShadow = '2px 2px 2px #000000'
      ..zIndex = '99';

    toolbar.append(new_indicator);
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
    el.append(menu);

    if (store.show_snapshots) {
      menu
        ..append(_openDialog)
        ..append(_copyDialog)
        ..append(_helpDialog);
      return;
    }

    menu
      ..append(_newProjectDialog)
      ..append(_openDialog)
      ..append(_copyDialog)
      ..append(_renameDialog)
      ..append(_saveDialog)
      ..append(_shareDialog)
      ..append(_downloadDialog)
      ..append(_removeDialog)
      ..append(_imageDialog)
      ..append(_menuDivider)
      ..append(_exportDialog)
      ..append(_importDialog)
      ..append(_menuDivider)
      ..append(_whatsNewDialog)
      ..append(_helpDialog);
  }

  get _openDialog=>       new MenuItem(new OpenDialog(this)).el;
  get _newProjectDialog=> new MenuItem(new NewProjectDialog(this)).el;
  get _renameDialog=>     new MenuItem(new RenameDialog(this)).el;
  get _copyDialog=>       new MenuItem(new CopyDialog(this)).el;
  get _saveDialog=>       new MenuItem(new SaveAction(this)).el;
  get _shareDialog=>      new MenuItem(new ShareDialog(this)).el;
  get _removeDialog=>     new MenuItem(new RemoveDialog(this)).el;
  get _downloadDialog=>   new MenuItem(new DownloadDialog(this)).el;
  get _exportDialog=>     new MenuItem(new ExportDialog(this)).el;
  get _importDialog=>     new MenuItem(new ImportDialog(this)).el;
  get _imageDialog=>      new MenuItem(new ImageDialog(this)).el;
  get _whatsNewDialog=>   new MenuItem(
                            new WhatsNewAction(this),
                            isHighlighted: _highlightWhatsNew
                          ).el;
  get _helpDialog=>       new MenuItem(new HelpAction(this)).el;
  get _menuDivider=>      new Element.hr();

  rememberWhatsNewClicked() {
    settings['clicked_whats_new'] = true;
    query("#somethingsnew").remove();
  }

  bool get _highlightWhatsNew => !_whatsNewClicked;

  bool get _whatsNewClicked =>
    (settings['clicked_whats_new'] != null) && settings['clicked_whats_new'];

  bool get _isFirstUse =>
    store.isEmpty ||
    (store.length == 1 && store.currentProjectTitle == 'Untitled');

  String get encodedContent => Gzip.encode(ice.content);

  _attachKeyboardHandlers() {
    Keys.shortcuts({
      'Ctrl+N, Ctrl+O, ⌘+O, Ctrl+Shift+H': ()=> _hideDialog(focus: false)
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

  _attachDropHandlers() {
    document.onDragOver.listen((e) {
      e.preventDefault();
      e.stopPropagation();
    });

    document.onDrop.listen((e) {
      e.preventDefault();
      e.stopPropagation();

      var file = e.dataTransfer.files[0];
      var title = file.name;

      var reader = new FileReader();
      reader.onLoad.listen((e) {
        import(reader.result.toString(), title);
      });
      reader.readAsText(file);
    });
  }

  import(String contents, String title) {
    // TODO: don't use exceptions for normal workflow
    try {
      _importFromJson(contents);
    } on FormatException {
      _importProjectFile(contents, title);
    }
  }

  _importProjectFile(String contents, String title) {
    _createNewProject({'code': contents}, named: title);
    showCurrentProject();
  }

  _importFromJson(String json) {
    var projects = JSON.decode(json);
    projects.reversed.forEach((project) {
      _createNewProject(project);
    });
    showCurrentProject();
  }

  _createNewProject(Map project, {named}) {
    var name = (named != null) ? named : project['filename'];
    if (store.containsKey(name)) {
      name = store.nextProjectNamed(name);
    }
    store[name] = project;
  }

  showCurrentProject() {
    content = store.projects[0]['code'];
  }


  _fullScreenStyles() {
    document.body.style
      ..margin = '0px'
      ..overflow = 'hidden';
  }

  _openProject() {
    var matchCompressedContent = new RegExp(r'#?B/');
    if (compressedContent.startsWith(matchCompressedContent)) {
      var title = store.nextProjectNamed('Untitled');
      content = Gzip.decode(compressedContent.replaceFirst(matchCompressedContent, ''));
      store[title] = {'code': content};
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

  _initializeSettingForFirstUse() {
    if (_isFirstUse) {
      settings['clicked_whats_new'] = true;
    }
  }

  _initializeMode() {
    if (mode == null) return;
    if (mode.startsWith('e')) ice.edit_only = true;
    if (mode.startsWith('g')) hideCode();
  }

  _startSnapshotter() {
    if (mode != null && mode.startsWith('s')) {
      store.show_snapshots = true;
      ice.read_only = true;
    }
    else {
      snapshotter = new Snapshotter(this);
    }
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
