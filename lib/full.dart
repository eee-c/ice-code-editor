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

    editorReady.then((_)=> _applyStyles());
    editorReady.then((_)=> content = store.isEmpty ?
      '' : store.projects.first['code']);
  }

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
      ..add(_openDialog)
      ..add(_renameMenuItem)
      ..add(_newProjectDialog)
      ..add(_renameDialog)
      ..add(_copyDialog)
      ..add(_saveMenu)
      ..add(_shareDialog)
      ..add(_removeDialog)
      ..add(_downloadDialog)
      ..add(_helpDialog);
  }

  get _openDialog=> OpenDialog(this).el;
  get _newProjectDialog=> new NewProjectDialog(this).el;
  get _renameDialog=> new RenameDialog(this).el;
  get _copyDialog=> new CopyDialog(this).el;
  get _saveMenu=> new SaveMenu(this).el;
  get _shareDialog=> new ShareDialog(this).el;
  get _removeDialog=> new RemoveDialog(this).el;
  get _downloadDialog=> new DownloadDialog(this).el;
  get _helpDialog=> new HelpDialog(this).el;

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
    if (store.isEmpty) return "Untitled";

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

    store[title] = {'code': content};

    query('.ice-dialog').remove();
  }

  String get encodedContent => Gzip.encode(ice.content);

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

_hideMenu() {
  queryAll('.ice-menu').forEach((e)=> e.remove());
}

_hideDialog() {
  queryAll('.ice-dialog').forEach((e)=> e.remove());
}

class RenameDialog {
  RenameDialog(Full full);
  Element get el {
    return new Element.html('<li>Rename</li>');
  }
}
class RemoveDialog {
  RemoveDialog(Full full);
  Element get el {
    return new Element.html('<li>Remove</li>');
  }
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
    return new Element.html('<li>Help</li>');
  }
}
