part of ice;

class CopyDialog extends Dialog implements MenuAction {
  CopyDialog(Full f): super(f);

  get name => 'Make a Copy';

  open() {
    var dialog = new Element.html(
      '''
      <div class=ice-dialog>
      <label>Name:<input type="text" size="30" value="$_copiedProjectName"></label>
      <button>Save</button>
      <button id=fake_enter_key></button>
      </div>
      '''
    );

    // Hack in lieu of KeyEvent tests
    dialog.query('button#fake_enter_key')
      ..onClick.listen((e)=> _copyProject())
      ..style.display = 'none';

    dialog.query('button').onClick
      ..listen((_)=> _copyProject());

    dialog.query('input').onKeyDown.
      listen((e) {
        if (e.keyCode != KeyCode.ENTER) return;
        _copyProject();
      });

    parent.children.add(dialog);

    dialog.query('input')
      ..focus();
  }

  get _copiedProjectName => store.nextProjectNamed();

  _copyProject() {
    store.show_snapshots = false;

    var title = _field.value;
    if (!new Validate(title, store, parent).isValid) return;

    store[title] = {'code': ice.content};

    query('.ice-dialog').remove();

    if (window.location.search.contains('s')) window.location.search = '';
  }

  InputElement get _field => query('.ice-dialog').query('input');
}
