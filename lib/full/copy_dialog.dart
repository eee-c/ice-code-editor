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
      </div>
      '''
    );

    dialog.query('button').onClick
      ..listen((_)=> _copyProject());

    dialog.query('input')
      ..onKeyUp.listen((e){if (_isEnterKey(e)) _copyProject();});

    parent.children.add(dialog);

    dialog.query('input')
      ..focus();
  }

  get _copiedProjectName => store.nextProjectNamed();

  _copyProject() {
    var title = _field.value;
    if (store.containsKey(title)) {
      var message = "There is already a project with that name";
      Notify.alert(message, parent: parent, test_mode: !ice.enable_javascript_mode);
      return;
    }

    store[title] = {'code': ice.content};

    query('.ice-dialog').remove();
  }

  InputElement get _field => query('.ice-dialog').query('input');
}
