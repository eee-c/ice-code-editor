part of ice;

class RenameDialog extends Dialog implements MenuAction {
  RenameDialog(Full f): super(f);

  get name => 'Rename';

  open(){
    var dialog = new Element.html(
      '''
      <div class=ice-dialog>
      <label>Name:<input type="text" size="30" value="$_currentProjectTitle"></label>
      <button>Rename</button>
      </div>
      '''
    );

    dialog.query('button').onClick
      .listen((_)=> _renameProject());

    dialog.query('input').onKeyUp
      .listen((e){if (_isEnterKey(e)) _renameProject();});

    parent.children.add(dialog);

    dialog.query('input').focus();
  }

  _renameProject() {
    var title = _field.value;

    if(store.containsKey(title)) {
      var message = "There is already a project with that name";

      Notify.alert(message, parent: parent);
      return;
    }

    var project = store.remove(_currentProjectTitle);
    store[title] = project;
    _hideDialog();
  }

  InputElement get _field => query('.ice-dialog').query('input');
  String get _currentProjectTitle => store.currentProjectTitle;
}
